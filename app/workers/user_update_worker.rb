class UserUpdateWorker
  RETRY_DELAY = 1

  include Sidekiq::Worker
  sidekiq_options :queue => :user_updates


  def perform(nickname)
    user = User.find_by_nickname(nickname)
    
    if not user
      return nil
    end

    logger.info 'Found user in database: ' + user.name

    begin
      #выбираем первого попавшегося и используем его твиттер для скачивания данных
      rand_user = User.where('secret is Not NULL').first(:order=>'RANDOM()')
      twitter = rand_user.twitter
      #twitter = Twitter

      logger.info 'Found random user in database: ' + rand_user.name

      time_gate = Time.now - 20.days

    
      twitter_user = twitter.user(nickname)

      if twitter_user.protected 
        logger.info 'User is protected !!! =('
        user.share_price = User::PROTECTED_PRICE
        user.base_price  = User::PROTECTED_PRICE
        user.save
        
        return user
      end

      timeline  = twitter.user_timeline(nickname, include_rts: 0, count: 200, include_entities: true).select{|t| t.created_at > time_gate}   
      logger.info 'Fetched user profile and timeline from twitter'
    rescue Twitter::Error::NotFound
      logger.info 'User not foud'
      return nil
    rescue Twitter::Error::Unauthorized
      logger.info 'Unauthorized'
      sleep(RETRY_DELAY)
      retry
    rescue Twitter::Error::BadRequest
      logger.info 'Bad request'
      sleep(RETRY_DELAY)
      retry
    rescue Twitter::Error::Forbidden
      logger.info 'Forbidden'
      return nil
    rescue Twitter::Error::ServiceUnavailable
      logger.info 'Service unavailible'
      sleep(RETRY_DELAY)
      retry
    end   


    user.tweets_num    = timeline.count || 0
    user.retweets_num  = timeline.inject(0){|a, b| a += b.retweet_count} || 0
    user.followers_num = twitter_user.followers_count || 0
    user.pop           = user.popularity || 0
    user.save
    user.reload

    #Определяем самый популярный твит пользователя
    max_tweet_num  = -1
    max_tweet_text = ''
    tweet_id_str   = ''
    media_url      = nil

    timeline.each do |tweet|
      if tweet.retweet_count > max_tweet_num
        #logger.info tweet.retweet_count
        max_tweet_num  = tweet.retweet_count
        max_tweet_text = tweet.text
        tweet_id_str   = tweet.id.to_s


        begin
          if tweet.media
            tweet.media.each do |m|
              url = m.media_url
              if url.index('jpg') or url.index('jpeg') or url.index('png')
                media_url = url
              end
            end
          else
            media_url = nil
          end
        rescue Exception => e
          logger.info "Broken loop."
          logger.info "Reason: #{e}"
          logger.info e.backtrace
        end



      end 
    end

    if (user.best_tweet_retweets_num <= max_tweet_num) or user.best_tweet_obsolete
      user.best_tweet_retweets_num = max_tweet_num
      user.best_tweet_text         = max_tweet_text
      user.best_tweet_id           = tweet_id_str
      if media_url
        user.best_tweet_media_url  = media_url
      end
      user.best_updated            = Time.now

      user.save
      user.reload

      user.update_best_tweet_param
      user.tweet_category = nil
      user.save
    end

   
    #New Formula 
    a = user.retweets_num/(user.tweets_num + 1.0)
    a = a/36.7
    a = Math::log(a + Math::E)
    a = a**(0.5)
    a = (a + 1)**7
    a = 7*a

    b = user.followers_num.to_f**(0.5)
    b = b/25.0
    b = Math::log(Math::E + b)
    b = b**(0.5)
    b = (1 + b)**11
    b = b*0.1
    
    price = a + b - 1092
    price = User::MINIMUM_PRICE if price < 0

    user.base_price  = price.round
    user.save
    user.reload

    user.share_price = (price*user.popularity_stocks_coefficient).round
    user.save
    logger.info 'Saved user to database ' + user.name

    user
  end
end
