class AddBestTweetIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :best_tweet_id, :string
  end
end
