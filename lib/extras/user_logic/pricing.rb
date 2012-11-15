module UserLogic
  module Pricing
    def update_share_price
      old_price = share_price
      self.share_price = nil if (not base_price) or base_price == -1
      self.share_price = StockMath.share_price(base_price, shares_in_stock).round

      if old_price != share_price
        PriceLog.create(user_id: id, price: share_price)
      end

      self
    end

    def is_protected?
      (base_price == -1)
    end

    def shares_in_stock
      my_shares.inject(0) { |a, b| a += b.count }
    end
  end
end