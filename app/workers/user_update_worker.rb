class UserUpdateWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :user_updates

  def perform(nickname)
    user = User.find_by_nickname(nickname)

    #выбираем первого попавшегося и используем его твиттер для скачивания данных
    # rand_user = User.where('secret is Not NULL').first(:order=>'RANDOM()')
    # twitter = rand_user.twitter

    time_gate = Time.now - 20.days
    timeline  = Twitter.user_timeline(nickname, include_rts: 0, count: 200).select{|t| t.created_at > time_gate}

    twitter_user = Twitter.user(nickname)

    rt, cnt, fw = 0, 0, 0
    begin
      # followers     = twitter.user(nickname).followers_count
      # timeline      = twitter.user_timeline(nickname, include_rts: 0, count: 200).select{|t| t.created_at > time_gate}
      # tweets        = timeline.count
      # retweets      = timeline.inject(0){|a, b| a += b.retweet_count}
      rt  = timeline.inject(0){|a, b| a += b.retweet_count}
      cnt = timeline.count
      flw = twitter_user.followers_count
    rescue
      rt, cnt, flw = 0, 0, 0
    end

    rt, cnt, flw = rt.to_f, cnt.to_f, flw.to_f

    a = Math::log10(10 + 100*rt/(cnt+1))
    b = Math::log10(10 + flw)
    c = Math::log10(10 + rt)

    d = Math::log10(user.my_shares.sum(:count)/1000.0 + 1)
    
    price = a**6 + b**6 + c**6 + d**6
    
    user.share_price = price.round    
    user.save

  end
end
