class UserUpdateWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :user_updates


  def perform(nickname)
    begin
      user = User.find_by_nickname(nickname)
    rescue
      logger.fatal 'User not found:' + nickname
      return 1
    end

    #выбираем первого попавшегося и используем его твиттер для скачивания данных
    rand_user = User.where('secret is Not NULL').first(:order=>'RANDOM()')
    twitter = rand_user.twitter
    #twitter = Twitter

    time_gate = Time.now - 20.days

    begin
      timeline  = twitter.user_timeline(nickname, include_rts: 0, count: 200).select{|t| t.created_at > time_gate}      
      twitter_user = twitter.user(nickname)

      if not twitter_user.protected 
        rt, cnt, fw = 0, 0, 0
        begin
          # followers     = twitter.user(nickname).followers_count
          # timeline      = twitter.user_timeline(nickname, include_rts: 0, count: 200).select{|t| t.created_at > time_gate}
          # tweets        = timeline.count
          # retweets      = timeline.inject(0){|a, b| a += b.retweet_count}
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
      end

    rescue
      logger.fatal 'Something went wrong with twitter profile of' + nickname
    end

  end
end
