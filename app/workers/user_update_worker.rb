class UserUpdateWorker
  RETRY_DELAY = 60*5

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
      timeline  = twitter.user_timeline(nickname, include_rts: 0, count: 200).select{|t| t.created_at > time_gate}   
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
      return nil
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
