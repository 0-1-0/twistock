class ChangeBestTweetUrlType < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.change :best_tweet_media_url, :text
    end
  end

  def self.down
    change_table :users do |t|
      t.change :best_tweet_media_url, :string
    end
  end
end
