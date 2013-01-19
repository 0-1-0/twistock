class BestTweet < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :tags
  attr_accessible :content, :media_url, :param, :retweets, :twitter_id

  validates :twitter_id, uniqueness: true
  validates :content, :retweets, :user_id, :twitter_id, :lang, presence: true

  has_one :activity_event, as: :source

  default_scope where(outdated: false)

  def update_retweets(twitter)
    self.retweets = twitter.status(twitter_id).retweets_count
    self.save
  end

  def gen_activity_event(user_retweets, user_tweets_count, user_followers_count, shares_in_stock)

    std_b_price = StockMath.base_price(user_retweets, user_tweets_count, user_followers_count)
    std_price   = StockMath.share_price(std_b_price, shares_in_stock)

    delta_b_price = StockMath.base_price(user_retweets - self.retweets, user_tweets_count, user_followers_count)
    delta_price   = StockMath.share_price(delta_b_price, shares_in_stock)

    ActivityEvent.create(
        user: user,
        source: self,
        price_change: std_price - delta_price
    )
  end
end
