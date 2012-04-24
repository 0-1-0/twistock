class UserUpdateWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :user_updates

  def perform(nickname)
    user = User.find_by_nickname(nickname)

    retweet_count = 0
    begin
      timeline = Twitter.user_timeline(nickname, count: 200)
      retweet_count = timeline.inject(0){|a, b| a += b.retweet_count}    
    rescue
      retweet_count = 0 
    end
    
    user.share_price = retweet_count
    user.save
  end
end