class AddOutdatedToBestTweets < ActiveRecord::Migration
  def change
    add_column :best_tweets, :outdated, :boolean, default: false
  end
end
