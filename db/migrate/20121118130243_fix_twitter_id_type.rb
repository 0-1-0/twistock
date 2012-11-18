class FixTwitterIdType < ActiveRecord::Migration
  def change
    change_column :best_tweets, :twitter_id, :string
  end
end