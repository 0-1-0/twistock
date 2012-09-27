class ChangeTypeOfBestTweetParam < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.change :best_tweet_param, :float
    end
  end

  def self.down
    change_table :users do |t|
      t.change :best_tweet_param, :integer
    end
  end
end
