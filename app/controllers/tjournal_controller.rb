class TjournalController < ApplicationController
  layout  'tjournal'

  def top_tweets
    @users_with_top_tweets = User.where('best_tweet_retweets_num > 100').order('best_tweet_param DESC').limit(64)
    @categories = @users_with_top_tweets.collect {|x| x.tweet_category}.uniq
  end

  def admin
    @users_with_top_tweets = User.where('best_tweet_retweets_num > 100').order('best_tweet_param DESC').limit(64)
    
  end

  def update
    user = User.find (params[:new_category]['user_id']).to_i
    user.tweet_category = params[:new_category]['category']
    user.save

    redirect_to :back
  end
end
