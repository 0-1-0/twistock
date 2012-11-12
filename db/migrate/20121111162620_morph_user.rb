class MorphUser < ActiveRecord::Migration
  def change
    rename_column :users, :uid, :twitter_id
    rename_column :users, :acivated, :activated

    remove_column :users, :best_tweet_text
    remove_column :users, :best_tweet_retweets_num
    remove_column :users, :best_updated
    remove_column :users, :best_tweet_param
    remove_column :users, :best_tweet_id
    remove_column :users, :best_tweet_media_url
    remove_column :users, :tweet_category
    remove_column :users, :retention_done
    remove_column :users, :pop
    remove_column :users, :followers_num
    remove_column :users, :retweets_num
    remove_column :users, :tweets_num
  end
end
