class User < ActiveRecord::Base
  after_find :update_stats

  has_many :portfel,        class_name: BlockOfShares, foreign_key: :holder_id
  has_many :my_shares,      class_name: BlockOfShares, foreign_key: :owner_id

  has_many :history,        class_name: Transaction, foreign_key: :owner_id

  has_many :transactions

  has_many :product_invoices

  attr_accessible :avatar, :money, :name, :nickname, :uid, :shares, :retention_shares, :token, :secret, :activated


  START_MONEY             = 0
  START_SHARES            = 200
  START_RETENTION_SHARES  = 100
  POPULARITY_UPDATE_DELAY = 2*7*24*60*60
  ANALYSES_UPDATE_DELAY   = 6.hours

  def to_param
    nickname
  end

  def self.find_or_create(id)
    user = (User.find_by_nickname(id) or User.create_from_twitter(id))
    user
  end

  def self.find_by_nicknames(ids)
    result = []

    ids.each do |id|
      user = User.find_or_create id
      if user
        result += [user]
      end
    end

    result
  end



  def has_starting_stocks
    if self.retention_shares and self.share_price
      return (self.retention_shares > 0 and self.share_price > 0)
    else
      return false
    end
  end

  def sell_starting_stocks
    self.sell_retention(self.retention_shares)
  end


  

  def profile_image
    return self.avatar.sub("_normal", "")
  end

  def update_from_twitter_oauth(auth)
    self.token  = auth.credentials.token
    self.secret = auth.credentials.secret

    self.save
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
    User.create(  uid:      auth.uid.to_i,
                  token:    auth.credentials.token,
                  secret:   auth.credentials.secret,
                  name:     auth.info.name,
                  nickname: auth.info.nickname,
                  avatar:   auth.info.image,
                  money:    User::START_MONEY,
                  shares:   User::START_SHARES,
                  retention_shares: User::START_RETENTION_SHARES
                ).update_stats
  end

  def self.create_from_twitter(nickname)
    begin
      info = Twitter.user(nickname)
    rescue
      return nil
    end
    User.create(  uid:      info.id,
                  name:     info.name,
                  nickname: info.screen_name,
                  avatar:   info.profile_image_url,
                  money:    User::START_MONEY,
                  shares:   User::START_SHARES,
                  retention_shares: User::START_RETENTION_SHARES
                ).update_stats
  end

  def self.try_to_find(uid)
    User.where(uid: uid).first
  end

  def self.find_by_nickname(nickname)
    User.where("nickname ~* '#{nickname}'").first
  end

  def available_shares
    shares - retention_shares
  end

  def buy_shares(owner, count)
    raise "You cannot buy 0 shares" unless count > 0

    cost = 0

    User.transaction do
      owner.reload
      self.reload

      raise "Stocks aren't ready for selling yet" unless owner.share_price
      raise "You cannot buy shares with zero price" if owner.share_price == 0

      cost = count*owner.share_price

      # проверяем на валидность
      raise "There are no #{count} shares"   unless owner.available_shares >= count
      raise "You haven't enough money"       unless self.money >= cost

      # проводим операцию
      owner.shares  -= count
      self.money    -= cost
      if bos = self.portfel.where(owner_id: owner.id).first
        bos.count += count
        bos.save
      else
        self.portfel << BlockOfShares.new(count: count, owner_id: owner.id)
      end

      #доп эмиссия (если нужно)
      if owner.available_shares < User::START_SHARES
        owner.shares *= 2
        owner.save
      end

      owner.update_share_price

      owner.save!
      self.save!


      # теперь фигачим транзакцию
      t = Transaction.create(
      user:   self,
      owner:  owner,
      action: 'buy',
      count:  count,
      price:  owner.share_price,
      cost:   cost)
      t.price = owner.share_price
      t.save

      #Пишем о транзакции в твиттер
      TweetWorker.perform_async(
      self.id, \
        "@" + self.nickname + ' ' +\
        t(:bought) + ' ' +\
        t.count.to_s +  ' ' +\
        t(:stocks_of) + ' ' +\
        "@" + owner.nickname + ' ' +\
        t(:on_twistock_com)\
      )

      # return self
      self
    end
  end

  

  def sell_shares(owner, count)
    raise "You cannot sell 0 shares" unless count > 0

    cost = 0

    User.transaction do
      self.reload
      owner.reload
      
      raise "You have not this shares" unless bos = self.portfel.where(owner_id: owner.id).first
      raise "You have not this shares" if bos.count < count

      owner.shares  += count
      bos.count     -= count

      if bos.count == 0
        bos.delete
      else
        bos.save
      end

      #Важен порядок следующих 3 операций!
      owner.update_share_price
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
    t.price = owner.share_price
    t.save

    #Пишем о транзакции в твиттер
    TweetWorker.perform_async(
      self.id, 
      "@" + self.nickname + \
      " sold " + t.count.to_s + \
      " stocks of @" + owner.nickname + \
      " on www.twistock.com #MonetizeSocialCapital"
    )


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

  def popularity_stocks_coefficient
    Math::log10(100*self.my_shares.sum(:count) + 10)
  end

  def update_share_price
      User.transaction do
        prev_day_transaction = self.history.where("created_at <= :time", {:time => Time.now - 1.day}).last

        if prev_day_transaction
          prev_price = prev_day_transaction.price
        else
          prev_price = self.share_price
        end         

        if self.base_price
          d = popularity_stocks_coefficient
          new_price = self.base_price + d**6
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

  def update_stats
    if Time.now - (last_update || Time.now - ANALYSES_UPDATE_DELAY) >= ANALYSES_UPDATE_DELAY
      User.transaction do
        self.last_update = Time.now
        self.save
      end
      UserUpdateWorker.perform_async(nickname)
      
      self
    end

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
    result = []
    price_data.each do |d|
      if d > 0
        result += [d - min_price_value]
      end
    end

    result
  end


end