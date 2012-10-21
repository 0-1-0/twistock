module UserLogic
  module BestTweets
    def clear_best_tweet_data
      self.best_tweet_id = nil
      self.best_tweet_text = nil
      self.best_tweet_retweets_num = -1
      self.best_tweet_media_url = nil
      self.best_tweet_param = 0.0

      self.save
      self
    end

    def best_tweet_obsolete?
      best_updated and (best_updated + Settings.best_update_delay < Time.now )
    end

    def update_best_tweet_param
      if (best_tweet_retweets_num > 0) and (followers_num > 0)
        self.best_tweet_param = best_tweet_retweets_num * 1.0/(followers_num + 1.0)
      else
        self.best_tweet_param = 0.0
      end

      self.save
      self
    end
  end
end