module StockMath
  def self.base_price(user_retweets, user_tweets_count, user_followers_count)
    a = user_retweets/(user_tweets_count + 1.0)
    a = a/36.7
    a = Math::log(a + Math::E)
    a = a**(0.5)
    a = (a + 1)**7
    a = 7*a

    b = user_followers_count.to_f**(0.5)
    b = b/25.0
    b = Math::log(Math::E + b)
    b = b**(0.5)
    b = (1 + b)**11
    b = b*0.1

    [Settings.minimum_price, a + b - 1092].max.round
  end

  def self.price_stock_coefficient(base_price, shares_in_stock)
    current_price = base_price.to_f || 0.0

    a = current_price/134000.0
    a *= shares_in_stock**2

    1 + 0.1*Math::log10(a+1)
  end

  def self.share_price(base_price, shares_in_stock)
    base_price * price_stock_coefficient(base_price, shares_in_stock)
  end

  def self.tweet_param(retweets, followers)
    retweets * 1.0/(followers/10_000 + 1.0)
  end
end