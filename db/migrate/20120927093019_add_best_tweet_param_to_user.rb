class AddBestTweetParamToUser < ActiveRecord::Migration
  def change
    add_column :users, :best_tweet_param, :integer, :default=>0
  end
end
