class BestTweet < ActiveRecord::Base
  belongs_to :user
  attr_accessible :content, :media_url, :param, :retweets, :twitter_id

  validates :twitter_id, uniqueness: true
  validates :content, :retweets, :user_id, :twitter_id, presence: true
end
