class UserUpdateWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :user_updates

  def perform(nickname)
    user = User.find_by_nickname(nickname)

    #выбираем первого попавшегося и используем его твиттер для скачивания данных
    rand_user = User.where('secret is Not NULL').first(:order=>'RANDOM()')
    twitter = rand_user.twitter

    time_gate = Time.now - 20.days

    retweets, tweets, followers = 0, 0, 0
    begin
      followers     = twitter.user(nickname).followers_count
      timeline      = twitter.user_timeline(nickname, include_rts: 0, count: 200).select{|t| t.created_at > time_gate}
      tweets        = timeline.count
      retweets      = timeline.inject(0){|a, b| a += b.retweet_count}
    rescue
      retweets, tweets, followers = 0, 0, 0
    end

    retweets, tweets, followers = retweets.to_f, tweets.to_f, followers.to_f
    
    user.base_price = (      
      270.0*( retweets/(tweets+1) ) + 22.0*retweets + followers/2.0 + 100.0
      ).round

    if user.base_price > User::MAXIMUM_PRICE/2
       user.base_price = ((User::MAXIMUM_PRICE/2) + ((1 + user.base_price - User::MAXIMUM_PRICE) * User::STEP)).round
    end
    
    user.share_price = (((user.my_shares.sum(:count) + 1000)/1000.0)*user.base_price).round
    
    user.save

  end
end
