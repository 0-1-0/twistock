module UserLogic
  module Pricing
    def update_share_price
      old_price = share_price
      if (not base_price) or base_price == -1
        self.share_price = nil
      else
        self.share_price = StockMath.share_price(base_price, shares_in_stock).round
      end

      if old_price != share_price
        PriceLog.create(user_id: id, price: share_price)
      end

      wipe_periodic_caches

      self
    end

    def is_protected?
      (base_price == -1)
    end

    def shares_in_stock
      my_shares.inject(0) { |a, b| a += b.count }
    end

    def wipe_periodic_caches
      delta = PriceLog.get_user_log(self, first_and_last: true, for: 1.day)
      self.daily_price_change   = (delta[1][0] - delta[0][0]) || 0

      delta = PriceLog.get_user_log(self, first_and_last: true, for: 1.week)
      self.weekly_price_change  = (delta[1][0] - delta[0][0]) || 0

      delta = PriceLog.get_user_log(self, first_and_last: true, for: 1.month)
      self.monthly_price_change = (delta[1][0] - delta[0][0]) || 0

      save
      self
    end
  end
end