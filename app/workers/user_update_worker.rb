class UserUpdateWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :user_updates

  def perform(nickname)
    user = User.find_by_nickname(nickname)
    time_gate = Time.now - 20.days

    retweets, tweets, followers = 0, 0, 0
    begin
      followers     = Twitter.user(nickname).followers_count
      timeline      = Twitter.user_timeline(nickname, include_rts: 0, count: 200).select{|t| t.created_at > time_gate}
      tweets        = timeline.count
      retweets      = timeline.inject(0){|a, b| a += b.retweet_count}
    rescue
      retweets, tweets, followers = 0, 0, 0
    end

    retweets, tweets, followers = retweets.to_f, tweets.to_f, followers.to_f
    
    user.share_price = ( 
      270.0*( retweets/(tweets+1) ) + 22.0*retweets + followers/2.0 + 100.0
      ).round
    user.save
  end
end