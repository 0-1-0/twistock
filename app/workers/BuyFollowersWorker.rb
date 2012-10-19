class BuyFollowersWorker
  include Sidekiq::Worker

  def perform(current_user, target_user)
    #get followers list
    cursor        = "-1"
    follower_ids  = []

    while cursor != 0 do
      followers = Twitter.follower_ids(target_user.nickname, :cursor => cursor)

      cursor = followers.next_cursor
      follower_ids += followers.ids
    end

    

    follower_ids.ids.each do |id|
      follower = Twitter.user(id)
      User.create_from_twitter_nickname(follower.screen_name)
    end

    follower_ids.ids.each do |id|
      follower = Twitter.user(id)
      begin
        follower_user = User.find_by_nickname(follower.screen_name)
        current_user.buy_shares(follower_user, 10)
      rescue
        follower_user.reload
      end

    end


  end
end
