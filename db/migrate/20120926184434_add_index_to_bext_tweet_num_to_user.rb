class AddIndexToBextTweetNumToUser < ActiveRecord::Migration
  def change
    add_index :users, :best_tweet_retweets_num
  end
end
