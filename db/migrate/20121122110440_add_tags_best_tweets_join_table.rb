class AddTagsBestTweetsJoinTable < ActiveRecord::Migration
  def change
    create_table :best_tweets_tags, id: false do |t|
      t.integer :tag_id
      t.integer :best_tweet_id
    end

    add_index :best_tweets_tags, [:tag_id, :best_tweet_id]
    add_index :best_tweets_tags, [:best_tweet_id, :tag_id]
  end
end
