module UserLogic
  module Pricing
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

    def price_is_obsolete
      unless last_update
        return true
        elseif Time.now - last_update >= Settings.analyses_update_delay
        return true
      end

      false
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

    def popularity_stocks_coefficient(count = 0)
      t = self.my_shares.sum(:count) + count
      current_price = base_price.to_f || 0

      a = current_price/134000.0
      a *= t*t

      m = 1 + 0.1*Math::log10(a+1)

      m
    end

    def price_after_transaction(count)
      (base_price*popularity_stocks_coefficient(count)).round
    end

  end
end