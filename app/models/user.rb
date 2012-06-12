class User < ActiveRecord::Base
  after_find :update_stats

  has_many :portfel,        class_name: BlockOfShares, foreign_key: :holder_id
  has_many :my_shares,      class_name: BlockOfShares, foreign_key: :owner_id

  has_many :transactions

  attr_accessible :avatar, :money, :name, :nickname, :uid, :shares, :retention_shares


  START_MONEY            = 20000
  START_SHARES           = 2048
  START_RETENTION_SHARES = 1000

  def to_param
    nickname
  end

  def self.create_from_twitter_oauth(auth)
    User.create(  uid:      auth.uid.to_i,
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

      raise "Shares aren't ready for selling yet" unless owner.share_price
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
    end

    # теперь фигачим транзакцию
    Transaction.create(
      user:   self,
      owner:  owner,
      action: 'buy',
      count:  count,
      cost:   cost)

    # return self
      self
  end

  def sell_shares(owner, count, user_to_redirect)
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

    Transaction.create(
      user:   self,
      owner:  owner,
      action: 'sell',
      count:  count,
      cost:   cost)

    user_to_redirect
  end

  def sell_retention(count)
    raise "You cannot sell 0 shares" unless count > 0
    
    cost = 0

    User.transaction do
      self.reload

      raise "Shares aren't ready for selling yet" unless self.share_price
      raise "You haven't enough shares" if count > self.retention_shares

      cost = self.share_price * count

      self.retention_shares -= count
      self.money += cost

      self.save
    end

    Transaction.create(
      user:   self,
      owner:  self,
      count:  count,
      cost:   cost,
      action: 'sell')

    self
  end

  def update_share_price
      User.transaction do
        prev_price = self.share_price



        prev_hour_transaction = self.transactions.where("created_at <= :time", {:time => Time.now - 3600}).last

        if prev_hour_transaction
          prev_hour_price = prev_hour_transaction.price
        else
          prev_hour_price = self.share_price
        end


         self.share_price = (
            (
              #Мультипликатор, имитирующий рыночный спрос/предложение
              (self.my_shares.sum(:count) + User::START_SHARES)/(1.0*User::START_SHARES)
              
            )*
              #Базовая цена аккаунта твиттера
              self.base_price
          ).round

         self.hour_delta_price = self.share_price - prev_hour_price
         
         self.save  
      end      
  end

  def update_stats
    #if Time.now - (last_update || Time.now - 7.hours) > 6.hours
    if Time.now - (last_update || Time.now - 7.hours) > 2.minutes
      User.transaction do
        self.last_update = Time.now
        #self.share_price = nil
        self.save
      end
      UserUpdateWorker.perform_async(nickname)
      self
    end
  end
end