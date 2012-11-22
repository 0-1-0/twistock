class AddLocaleToBestTweets < ActiveRecord::Migration
  def change
    add_column :best_tweets, :lang, :string
  end
end
