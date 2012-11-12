module UserLogic
  module Trading

    # TODO: перевод ошибок, выдача их пользователю
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

        self
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

      # Пишем о транзакции в твиттер
      if twitter_translation?
        TweetWorker.sell_message(t)
      end

      self
    end
  end
end