class CreateBestTweets < ActiveRecord::Migration
  def change
    create_table :best_tweets do |t|
      t.references :user
      t.integer :twitter_id
      t.text :media_url
      t.integer :retweets
      t.text :content
      t.float :param

      t.timestamps
    end

    add_index :best_tweets, :user_id
  end
end
