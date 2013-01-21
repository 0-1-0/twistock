module UserLogic
  module Trading
    module StandartError
      def initialize(message)
        super(message || @standart_message)
      end
    end

    # Throws when uninitialized or protected user
    class UninitializedUserError < Exception
      @standart_message = "Shares aren't ready for selling yet"
      include StandartError
    end

    class BuyZeroSharesError < Exception
      @standart_message = "You cannot buy 0 shares"
      include StandartError
    end

    class SellZeroSharesError < Exception
      @standart_message = "You cannot sell 0 shares"
      include StandartError
    end

    class NotEnoughMoneyError < Exception
      @standart_message = "You haven't enough money"
      include StandartError
    end

    class NotEnoughSharesError < Exception
      @standart_message = "You haven't enough money"
      include StandartError
    end

    class NotFollowerError < Exception
      @standart_message = "Available only for followers"
      include StandartError
    end

    # NOW WRITE THE METHODS!!!

    def buy_shares(owner, count)
      raise BuyZeroSharesError unless count > 0

      cost = 0
      price_change = 0

      if owner.is_hidden?
        raise NotFollowerError unless owner.has_follower?(current_user)
      end

      User.transaction do
        owner.reload
        self.reload

        raise UninitializedUserError  unless owner.share_price

        price = StockMath.share_price(owner.base_price, owner.shares_in_stock + count)
        cost = count*price

        raise NotEnoughMoneyError     unless self.money >= cost

        # проводим операцию
        self.money   -= cost
        if (bos = portfel.where(owner_id: owner.id).first)
          bos.count += count
          bos.save
        else
          self.portfel << BlockOfShares.new(count: count, owner_id: owner.id)
        end

        price_change  = owner.share_price
        owner.update_share_price
        price_change  = owner.share_price - price_change
        owner.update_popularity

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
          cost:   cost
      )


      #Пишем о транзакции в твиттер
      if twitter_translation?
        TweetWorker.buy_message(t)
      end
      #Пишем о транзакции в на почту
      MailWorker.buy_message(t)

      # Добавляем событие в ленту
      ActivityEvent.create(
          user: owner,
          price_change: price_change,
          source: t
      )

      self
    end

    def sell_shares(owner, count)
      raise SellZeroSharesError unless count > 0

      cost = 0
      price_change = 0

      User.transaction do
        self.reload
        owner.reload

        raise NotEnoughSharesError unless bos = self.portfel.where(owner_id: owner.id).first
        raise NotEnoughSharesError if bos.count < count

        bos.count     -= count
        if bos.count == 0
          bos.delete
        else
          bos.save
        end

        # Важен порядок следующих 5 операций!
        price_change  = owner.share_price
        owner.update_share_price
        price_change  = owner.share_price - price_change
        owner.update_popularity
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

      # Добавляем событие в ленту
      ActivityEvent.create(
          user: owner,
          price_change: price_change,
          source: t
      )

      # Пишем о транзакции в твиттер
      if twitter_translation?
        TweetWorker.sell_message(t)
      end
      # Пишем о транзакции в на почту
      MailWorker.sell_message(t)

      self
    end
  end
end