class UserUpdateWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :user_updates


  def perform(nickname)
    user = User.find_by_nickname(nickname)
    
    if not user
      return nil
    end

    #выбираем первого попавшегося и используем его твиттер для скачивания данных
    rand_user = User.where('secret is Not NULL').first(:order=>'RANDOM()')
    twitter = rand_user.twitter
    #twitter = Twitter

    time_gate = Time.now - 20.days

    begin
      twitter_user = twitter.user(nickname)
      timeline  = twitter.user_timeline(nickname, include_rts: 0, count: 200).select{|t| t.created_at > time_gate}   
    rescue Twitter::Error::NotFound
      return nil
    rescue Twitter::Error::Unauthorized
      return nil
    rescue Twitter::Error::BadRequest
      return nil
    rescue Twitter::Error::ServiceUnavailable
      sleep(60*5)
      retry
    end   

    if twitter_user.protected 
      user.share_price = User::PROTECTED_PRICE
      user.base_price  = User::PROTECTED_PRICE
      user.save
      
      return user
    end

    begin
      rt  = timeline.inject(0){|a, b| a += b.retweet_count}
      cnt = timeline.count
      flw = twitter_user.followers_count

      pop = user.popularity_stocks_coefficient
    rescue
      rt, cnt, flw, pop = 0, 0, 0, 0
    end

    rt, cnt, flw = rt.to_f, cnt.to_f, flw.to_f

    a = Math::log10(10 + 100*rt/(cnt+1))
    b = Math::log10(10 + flw)
    c = Math::log10(10 + rt)
    d = pop       
    
    price = a**6 + b**6 + c**6 + d**6
    
    user.share_price = price.round    
    user.base_price  = (a**6 + b**6 + c**6).round

    user.save
    user
  end
end
