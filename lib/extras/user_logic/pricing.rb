module UserLogic
  module Pricing
    def share_price
      Rails.cache.fetch "user_share_price_#{id}", expires_in: 30.minutes do
        return base_price
        # TODO: тут надо логику продумать получше
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
    end

    # TODO: это вообще переписать на логи от изменения цены (еще одна таблица/модель)
    #def price_dynamics_data
    #  price_data = self.history.collect(&:price).select { |x| x > 0 } + [self.share_price || 0]
    #  if price_data.size < 2
    #    price_data = price_data*2
    #  end
    #
    #  min_price_value = price_data.min
    #  result = [min_price_value]
    #  price_data.each do |d|
    #    if d > 0
    #      result += [d - min_price_value]
    #    end
    #  end
    #
    #  result
    #end

    # TODO: вытащить в Math оба метода
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