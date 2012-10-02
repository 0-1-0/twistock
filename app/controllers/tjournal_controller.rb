class TjournalController < ApplicationController
  layout  'tjournal'

  def top_tweets
    @users_with_top_tweets = User.where('best_tweet_retweets_num > 100').order('best_tweet_param DESC').limit(64)
  end

  def admin
  end
end
