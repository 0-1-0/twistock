# encoding: utf-8
class User < ActiveRecord::Base
  after_find :update_profile

  after_create :follow_twistock

  has_many :portfel,        class_name: BlockOfShares, foreign_key: :holder_id
  has_many :my_shares,      class_name: BlockOfShares, foreign_key: :owner_id

  has_many :history,        class_name: Transaction, foreign_key: :owner_id

  has_many :transactions

  has_many :product_invoices

  attr_accessible :avatar, :money, :name, :nickname
  attr_accessible :uid, :shares, :retention_shares
  attr_accessible :token, :secret, :activated
  attr_accessible :pop, :tweets_num, :retweets_num, :followers_num
  attr_accessible :best_tweet_text, :best_tweet_retweets_num, :best_updated, :best_tweet_param
  attr_accessible :best_tweet_media_url

  scope :random, ->(size) { order('RANDOM()').limit(size) }
  scope :highest_value, ->(size) { where{share_price != nil}.order{share_price.desc}.limit(size) }

  START_MONEY             = 0
  START_SHARES            = 200
  START_RETENTION_SHARES  = 100
  POPULARITY_UPDATE_DELAY = 2.weeks
  ANALYSES_UPDATE_DELAY   = 2.hours
  POPULARITY_POWER        = 6
  BEST_UPDATE_DELAY       = 2.weeks

  EN_LOCALE = 'en'
  RU_LOCALE = 'ru'

  PROTECTED_PRICE = 1
  MINIMUM_PRICE   = 10

  def to_param
    nickname
  end

  def best_tweet_obsolete
    if best_updated
      return (best_updated + User::BEST_UPDATE_DELAY < Time.now )
    else
      return false
    end
  end

  def update_best_tweet_param
    if best_tweet_retweets_num >= 0
      best_tweet_param = best_tweet_retweets_num*1.0/((followers_num || 0) + 1)
    else
      best_tweet_param = 0
    end
  end


  def has_credentials
    if token and secret
      return true
    else
      return false
    end
  end

  def follow_twistock
    if has_credentials
      FollowWorker.perform_async(self.id)
    end
  end

  def self.find_or_create(id)
    user = (User.find_by_nickname(id) or User.create_from_twitter(id))
    user
  end

  def self.find_by_nicknames(ids, opts = {})
    result = []

    ids.each do |id|
      user = User.find_or_create id
      if user
        result << user
      end
    end

    result.shuffle! if opts[:shuffle]

    result = result[0..opts[:limit]] if opts[:limit]

    result
  end

  def stocks_in_portfel(user)
    block_of_shares = portfel.where(owner_id: user.id).first
    
    if block_of_shares
      return block_of_shares.count
    else
      return 0
    end
  end
  
  #Use with care!!!
  def self.update_all_profiles
    User.find(:all).each do |u|
      UserUpdateWorker.perform_async(u.nickname)
    end
  end
  

  def profile_image
    return self.avatar.sub("_normal", "")
  end

  def update_oauth_info_if_neccesary(auth)
    if (not self.token? or not self.secret?)
      self.token  = auth.credentials.token
      self.secret = auth.credentials.secret

      self.save
    end
  end

  #Twitter client methods  
  def twitter
    consumer_key    = ENV['TWITTER_CONSUMER_KEY']    || 'Jr8mGbKWWCgHr99rzjHa3g'
    consumer_secret = ENV['TWITTER_CONSUMER_SECRET'] || 'a86Mfo1t4du7NVgFyplFfEhJ5j80esEUuknKRRtPJ60'

    @twitter_user ||= Twitter::Client.new(
      :consumer_key=>consumer_key, 
      :consumer_secret=>consumer_secret, 
      :oauth_token => token, 
      :oauth_token_secret => secret
      )
  end


  def self.create_from_twitter_oauth(auth)
    user = User.create(  uid:      auth.uid.to_i,
                  token:    auth.credentials.token,
                  secret:   auth.credentials.secret,
                  name:     auth.info.name,
                  nickname: auth.info.nickname,
                  avatar:   auth.info.image,
                  money:    User::START_MONEY,
                  shares:   User::START_SHARES,
                  retention_shares: User::START_RETENTION_SHARES
                )
    user.update_profile
    user
  end



  def self.create_from_twitter(nickname)
    begin
      info = Twitter.user(nickname)
    rescue
      return nil
    end
    user = User.create(  uid:      info.id,
                  name:     info.name,
                  nickname: info.screen_name,
                  avatar:   info.profile_image_url,
                  money:    User::START_MONEY,
                  shares:   User::START_SHARES,
                  retention_shares: User::START_RETENTION_SHARES
                )
    user.update_profile
    user
  end

  def self.try_to_find(uid)
    User.where(uid: uid).first
  end

  def self.find_by_nickname(nickname)
    user = User.where("upper(nickname) = upper('#{nickname}')").first
    # if !user.base_price or !user.share_price
    #   user.update_profile
    # end

    return user
  end

  def buy_shares(owner, count)
    raise "You cannot buy 0 shares" unless count > 0

    cost = 0

    User.transaction do
      owner.reload
      self.reload

      raise "Stocks aren't ready for selling yet" unless owner.share_price
      raise "You cannot buy shares with zero price" if owner.share_price == 0


      price = owner.price_after_transaction(count)
      cost = count*price

      raise "You haven't enough money"       unless self.money >= cost      

      # проводим операцию
      #owner.shares  -= count
      self.money   -= cost
      if bos = self.portfel.where(owner_id: owner.id).first
        bos.count += count
        bos.save
      else
        self.portfel << BlockOfShares.new(count: count, owner_id: owner.id)
      end

      owner.update_share_price
      owner.reload       
      #доп эмиссия (если нужно)
      # if owner.available_shares < User::START_SHARES
      #   owner.shares *= 2
      #   owner.save
      # end      

      owner.save!
      self.save!
    end

    # теперь фигачим транзакцию
    t = Transaction.create(
    user:   self,
    owner:  owner,
    action: 'buy',
    count:  count,
    price:  owner.share_price,
    cost:   cost)


    #Пишем о транзакции в твиттер
    if twitter_translation?
      TweetWorker.buy_message(t)
    end

    self
  end

  

  def sell_shares(owner, count)
    raise "You cannot sell 0 shares" unless count > 0

    cost = 0

    User.transaction do
      self.reload
      owner.reload
      
      raise "You have not this shares" unless bos = self.portfel.where(owner_id: owner.id).first
      raise "You have not this shares" if bos.count < count

      #owner.shares  += count
      bos.count     -= count
      if bos.count == 0
        bos.delete
      else
        bos.save
      end


      #Важен порядок следующих 3 операций!
      owner.update_share_price
      owner.reload

      cost = count*owner.share_price
      self.money += cost

      owner.save
      self.save
    end

    t = Transaction.create(
      user:   self,
      owner:  owner,
      action: 'sell',
      count:  count,
      price:  owner.share_price,
      cost:   cost)

    #Пишем о транзакции в твиттер
    if twitter_translation?
      TweetWorker.sell_message(t)
    end

    self
  end



  def sell_retention(count)
    raise "You cannot sell 0 shares" unless count > 0
    
    cost = 0

    User.transaction do
      self.reload

      raise "Stocks aren't ready for selling yet" unless self.share_price
      raise "You haven't enough shares" if count > self.retention_shares

      cost = self.share_price * count

      self.retention_shares -= count
      self.money += cost

      self.save
    end

    t = Transaction.create(
      user:   self,
      owner:  self,
      count:  count,
      cost:   cost,
      price:  self.share_price,
      action: 'sell')

    self
  end

  def popularity_stocks_coefficient(count=0)
    d = Math::log10(2*(self.my_shares.sum(:count) + count) + 10)
    d = d**POPULARITY_POWER

    return d
  end

  def price_after_transaction(count)
    return base_price + popularity_stocks_coefficient(count)
  end

  def update_share_price
      #self.update_profile
      
      User.transaction do
        prev_day_transaction = self.history.where("created_at <= :time", {:time => Time.now - 1.day}).last

        if prev_day_transaction
          prev_price = prev_day_transaction.price
        else
          prev_price = self.share_price
        end         

        if self.base_price
          new_price = self.base_price + popularity_stocks_coefficient
        else
          new_price = self.share_price
        end

        if new_price and prev_price
          self.hour_delta_price = (new_price - prev_price).to_i
          self.save
           
          self.share_price = new_price.to_i
           
          self.save  
        end
      end      
  end

  def update_profile
    if price_is_obsolete
      UserUpdateWorker.perform_async(nickname)
      User.transaction do
        self.last_update = Time.now
        self.save
      end
      
      self
    end

  end


  def price_is_obsolete
    if not last_update
      return true
    elseif Time.now - last_update >= ANALYSES_UPDATE_DELAY
      return true
    end

    return false
  end

  def popularity
    self.history.count#.where("created_at >= :time", {:time => Time.now - User::POPULARITY_UPDATE_DELAY}).count
  end

  def price_dynamics_data
    price_data = self.history.collect(&:price).select { |x| x > 0 } + [self.share_price || 0]
    if price_data.size < 2
      price_data = price_data*2 
    end

    min_price_value = price_data.min
    result = [min_price_value]
    price_data.each do |d|
      if d > 0
        result += [d - min_price_value]
      end
    end

    result
  end

  # Если у пользователя есть его акции - их надо продать.
  # Используется чтобы инициировать
  # первичное получение денег игроком.
  def sell_all_retention
    if retention_shares > 0 and share_price
      sell_retention(retention_shares)
    end
  end
end
