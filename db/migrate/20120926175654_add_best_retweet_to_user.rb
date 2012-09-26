class AddBestRetweetToUser < ActiveRecord::Migration
  def change
    add_column :users, :best_tweet_text, :text
    add_column :users, :best_tweet_retweets_num, :integer, :default=>-1
    add_column :users, :best_updated, :datetime
  end
end
