class UserUpdateWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :user_updates

  def is_image?(url)
    url.index('.jpg') or url.index('.jpeg') or url.index('.png') or url.index('.gif')
  end

  def is_youtube?(url)
    url.index('youtube')
  end

  # Дает подключение к твиттеру. Использует случайные token и secret из базы.
  def get_twitter
    rand_user = User.where{secret != nil}.order('RANDOM()').first
    logger.info 'Found random user in database: ' + rand_user.name
    rand_user.twitter
  end

  def get_timeline(twitter, nickname)
    time_gate = Time.now - (Settings.users_timegate).days
    twitter.user_timeline(nickname, include_rts: 0, count: 200, include_entities: true)
      .select{|t| t.created_at > time_gate}
      .tap { logger.info 'Fetched user timeline from twitter' }
  end

  def get_best_tweet(timeline, prev_best_retweets, followers_count, used_tweets = [])
    best_tweet = BestTweet.new(retweets: 0)

    top_time_gate     = Time.now - Settings.best_tweet_update_delay
    top_time_line     = timeline.select{|t| t.created_at > top_time_gate}
    best_tweet_index  = nil

    top_time_line.each.with_index do |tweet, i|
      if (tweet.retweet_count > best_tweet.retweets) and (not used_tweets.include?(tweet.id.to_s))
        best_tweet.retweets = tweet.retweet_count
        best_tweet_index    = i
      end
    end

    return nil unless best_tweet_index

    if prev_best_retweets <= best_tweet.retweets
      tweet = top_time_line[best_tweet_index]

      best_tweet.twitter_id = tweet.id.to_s
      best_tweet.content    = tweet.text
      best_tweet.lang       = tweet.text.lang
      best_tweet.param      = StockMath.tweet_param(best_tweet.retweets, followers_count)

      if tweet.urls and tweet.urls.length > 0
        url = tweet.urls[0].expanded_url
        if is_image?(url) or is_youtube?(url)
          best_tweet.media_url = url
        end
      end

      if tweet.media and tweet.media.length > 0
        tweet.media.each do |entity|
          if is_image?(entity.media_url) or is_youtube?(entity.media_url)
            best_tweet.media_url = entity.media_url
          end
        end
      end

      return best_tweet
    end

    nil
  end

  def perform(nickname)
    user = User.find_by_nickname(nickname)

    unless user
      Event.create tag: 'error',
                   source: 'UserUpdateWorker',
                   content: "user #{nickname} not found"
      return nil
    end

    logger.info 'Found user in database: ' + user.name

    begin
      #выбираем первого попавшегося и используем его твиттер для скачивания данных
      twitter       = get_twitter
      twitter_user  = twitter.user(nickname)

      if twitter_user.protected # запрещать покупку таких пользователей
        logger.info 'User is protected !!! =('
        user.base_price  = -1 # -1 - значит нельзя покупать
        user.share_price = nil
        user.save

        return user
      end

      timeline = get_timeline(twitter, nickname)
    rescue Twitter::Error::ClientError => e
      msg = "#{nickname}: twitter says '#{e.message}'"
      logger.info msg
      Event.create tag: 'error',
                   source: 'UserUpdateWorker',
                   content: msg
                   
      raise 'rate limit exceed for random user, trying to perform analys with other one'
    end
    tweets_count    = timeline.count || 0
    retweets_count  = timeline.inject(0){|a, b| a += b.retweet_count} || 0
    followers_count = twitter_user.followers_count || 0
    shares_in_stock = user.shares_in_stock


    # Определяем самый популярный твит пользователя

    # will be useful in future
    #user.best_tweet.update_retweets(twitter) if user.best_tweet

    user.best_tweets.update_all(outdated: true)

    used_ids = []

    if (t1 = get_best_tweet(timeline, 0, followers_count))
      used_ids << t1.twitter_id
    end

    if (t2 = get_best_tweet(timeline, 0, followers_count, used_ids))
      used_ids << t2.twitter_id
    end

    if (t3 = get_best_tweet(timeline, 0, followers_count, used_ids))
      used_ids << t3.twitter_id
    end
    user.best_tweets = [t1, t2, t3].compact

    user.best_tweets.each do |bt|
      bt.gen_activity_event(retweets_count, tweets_count, followers_count, shares_in_stock)
    end


    user.base_price  = StockMath.base_price(retweets_count, tweets_count, followers_count)
    user.update_share_price
    user.update_popularity

    user.save

    user.my_friends if user.has_credentials?

    logger.info 'Save user to database: ' + user.name

    # на случай, если новенький
    user.init_first_money if user.has_credentials?
  end
end
