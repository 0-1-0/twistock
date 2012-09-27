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

    #выбираем первого попавшегося и используем его твиттер для скачивания данных
    rand_user = User.where('secret is Not NULL').first(:order=>'RANDOM()')
    twitter = rand_user.twitter
    #twitter = Twitter

    logger.info 'Found random user in database: ' + rand_user.name

    time_gate = Time.now - 20.days

    begin
      twitter_user = twitter.user(nickname)
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

    if twitter_user.protected 
      logger.info 'User is protected !!! =('
      user.share_price = User::PROTECTED_PRICE
      user.base_price  = User::PROTECTED_PRICE
      user.save
      
      return user
    end

    user.tweets_num    = timeline.count
    user.retweets_num  = timeline.inject(0){|a, b| a += b.retweet_count}
    user.followers_num = twitter_user.followers_count
    user.pop           = user.popularity
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
            url = tweet.urls[0]
            if url
              media_url = url.expanded_url
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

    if (user.best_tweet_retweets_num < max_tweet_num) or user.best_tweet_obsolete
      user.best_tweet_retweets_num = max_tweet_num
      user.best_tweet_text         = max_tweet_text
      user.best_tweet_id           = tweet_id_str
      if media_url
        user.best_tweet_media_url  = media_url
      end
      user.best_updated            = Time.now

      user.save
    end

   

    rt   = user.retweets_num.to_f
    cnt  = user.tweets_num.to_f
    flw  = user.followers_num.to_f
    pop  = user.popularity_stocks_coefficient

    a = Math::log10(10 + 100*rt/(cnt+1))
    b = Math::log10(10 + flw)
    c = Math::log10(10 + rt)     
    
    price = a**6 + b**6 + c**6 + pop
    
    user.share_price = price.round    
    user.base_price  = (a**6 + b**6 + c**6).round

    logger.info 'Saved user to database ' + user.name

    user.save
    user
  end
end
