# encoding: utf-8
class User < ActiveRecord::Base
  # CALLBACKS
  # TODO: is it necessary?
  after_find :update_profile
  after_create :follow_twistock

  # RELATIONS
  has_many :portfel,    class_name: BlockOfShares, foreign_key: :holder_id
  has_many :my_shares,  class_name: BlockOfShares, foreign_key: :owner_id

  has_many :history,    class_name: Transaction, foreign_key: :owner_id
  has_many :transactions

  has_many :product_invoices

  # ACCESSORS
  attr_accessible :avatar, :money, :name, :nickname,
                  :uid, :shares, :retention_shares,
                  :token, :secret, :activated,
                  :pop, :tweets_num, :retweets_num, :followers_num,
                  :best_tweet_text, :best_tweet_retweets_num, :best_updated,
                  :best_tweet_param, :best_tweet_media_url

  # SCOPES
  scope :random,        ->(size) { order('RANDOM()').limit(size) }
  scope :highest_value, ->(size) { where{share_price != nil}.order{share_price.desc}.limit(size) }

  # TODO: extract to initializer class
  START_MONEY             = 0
  START_SHARES            = 200
  START_RETENTION_SHARES  = 100
  POPULARITY_UPDATE_DELAY = 2.weeks
  ANALYSES_UPDATE_DELAY   = 2.hours
  POPULARITY_POWER        = 6
  BEST_UPDATE_DELAY       = 1.day

  POPULARITY_CONSTANT = 100.0

  EN_LOCALE = 'en'
  RU_LOCALE = 'ru'

  PROTECTED_PRICE = 1
  MINIMUM_PRICE   = 2

  # CLASS METHODS
  class << self
    def find_by_nickname(nickname)
      user = User.where("upper(nickname) = upper('#{nickname}')").first
      # if !user.base_price or !user.share_price
      #   user.update_profile
      # end

      return user
    end

    def find_by_nicknames(ids, opts = {})
      ids.map!(&:upcase)

      # создаем несуществующих
      exists = User.where{upper(nickname).in ids}.select(:nickname)
      .map(&:nickname).map(&:upcase)
      (ids - exists).each do |id|
        User.find_or_create id
      end

      # сама выборка
      result = User.where{upper(nickname).in ids}
      result = result.includes(:history)  if opts[:history]
      result = result.order('RANDOM()')   if opts[:shuffle]
      result = result.limit(opts[:limit]) if opts[:limit]

      result
    end

    def find_or_create(id)
      user = (User.find_by_nickname(id) or User.create_from_twitter(id))
    end

    #Use with care!!!
    def update_all_profiles
      User.all.each do |u|
        UserMassUpdateWorker.perform_async(u.nickname)
      end
    end

    def create_from_twitter_oauth(auth)
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

    def create_from_twitter(nickname)
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

    def try_to_find(uid)
      User.where(uid: uid).first
    end
  end # class << self

  # INSTANCE METHODS

  def to_param
    nickname
  end

  def clear_best_tweet_data
    self.best_tweet_id = nil
    self.best_tweet_text = nil
    self.best_tweet_retweets_num = -1
    self.best_tweet_media_url = nil
    self.best_tweet_param = 0.0

    self.save
  end

  def best_tweet_obsolete
    if best_updated
      (best_updated + User::BEST_UPDATE_DELAY < Time.now )
    else
      false
    end
  end

  def update_best_tweet_param
    if (self.best_tweet_retweets_num > 0) and (self.followers_num > 0)
      self.best_tweet_param = self.best_tweet_retweets_num*1.0/(self.followers_num + 1.0)
    else
      self.best_tweet_param = 0.0
    end

    self.save
  end


  def has_credentials
    token and secret and true or false # чтобы всегда возвращало bool
  end

  def follow_twistock
    if has_credentials
      FollowWorker.perform_async(self.id)
    end
  end

  def stocks_in_portfel(user)
    block_of_shares = portfel.where(owner_id: user.id).first
    
    block_of_shares ? block_of_shares.count : 0
  end

  def profile_image
    self.avatar.sub("_normal", "")
  end

  def update_oauth_info_if_neccesary(auth)
    unless token? and secret?
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

  def popularity_stocks_coefficient(count = 0)
    t = self.my_shares.sum(:count) + count
    current_price = base_price.to_f || 0

    a = current_price/134000.0
    a *= t
    a *= t

    m = 1 + 0.1*Math::log10(a+1)

    m
  end

  def price_after_transaction(count)
    (base_price*popularity_stocks_coefficient(count)).round
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
          new_price = (self.base_price*popularity_stocks_coefficient).round
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
    # хак для запросов использующих .select(:nickname) и подобных
    begin
      last_update
    rescue
      return
    end 

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
    unless last_update
      return true
    elseif Time.now - last_update >= ANALYSES_UPDATE_DELAY
      return true
    end

    false
  end

  def popularity
    self.history.where("created_at >= :time", {:time => Time.now - User::POPULARITY_UPDATE_DELAY}).count
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
