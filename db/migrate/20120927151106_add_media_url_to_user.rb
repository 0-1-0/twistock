class AddMediaUrlToUser < ActiveRecord::Migration
  def change
    add_column :users, :best_tweet_media_url, :string
  end
end
