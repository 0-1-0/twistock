module UserLogic
  # TODO: это вообще нужно нивелировать
  module BestTweets
    def clear_best_tweet_data
      self.best_tweet.destroy if self.best_tweet

      save
      self
    end

    def update_best_tweet_param
      if (best_tweet.retweets_num > 0) and (followers_num > 0)
        self.best_tweet_param = best_tweet_retweets_num * 1.0/(followers_num + 1.0)
      else
        self.best_tweet_param = 0.0
      end

      self.save
      self
    end
  end
end