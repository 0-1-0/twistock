class StatisticsController < ApplicationController
  def index
    @user_growth      = calculate_user_growth()
    @best_tweets_stat = calculate_best_tweets_langs()
    @best_tweet_distribution = calculate_best_tweets_popularity_distribution()
  end

  def calculate_user_growth
    Rails.cache.fetch "user_growth", expires_in: 1.day do
      result = []
      30.times do |t|
        result += [User.where('created_at < ?', Time.now - 30.days + t.days).count]
      end

      result
    end
  end

  def calculate_best_tweets_langs
    Rails.cache.fetch 'best_tweets_langs', expires_in: 1.day do
      result = {}
      result['en'] = BestTweet.where(:lang=>'en').count
      result['ru'] = BestTweet.where(:lang=>'ru').count

      result
    end
  end

  
  def calculate_best_tweets_popularity_distribution
    Rails.cache.fetch 'tweets_distribution', expires_in: 1.day do
      result = {}
      points = [10000000,10000,1000,500,300,200,100,50,10,1,0]

      for i in 0..points.size-2
        result[points[i+1]] = BestTweet.where('retweets < ?', points[i]).where('retweets >= ?', points[i+1]).count
      end

      result
    end
  end

end
