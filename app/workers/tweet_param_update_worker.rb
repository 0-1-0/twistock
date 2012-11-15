# INFO: старье
class TweetParamUpdateWorker
  include Sidekiq::Worker

  def perform(id)
    user = User.find(id)
    if user.best_tweet_retweets_num > 0 and user.followers_num > 0
      user.best_tweet_param = user.best_tweet_retweets_num.to_f/(user.followers_num.to_f)
      logger.info 'processed param: ' + user.best_tweet_param.to_s
    else
      user.best_tweet_retweets_num = -1
      logger.info 'Fail'
    end

    user.save
  end


end
