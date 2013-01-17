class BestTweet < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :tags
  attr_accessible :content, :media_url, :param, :retweets, :twitter_id

  validates :twitter_id, uniqueness: true
  validates :content, :retweets, :user_id, :twitter_id, :lang, presence: true

  has_one :activity_event, as: :source

  def update_retweets(twitter)
    self.retweets = twitter.status(twitter_id).retweets_count
    self.save
  end
end
