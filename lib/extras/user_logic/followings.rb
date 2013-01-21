module UserLogic
  module Followings
    def update_followers
      t_ids = twitter.follower_ids.ids
      au_ids = User.where{twitter_id.in(t_ids)}.where{(secret != nil) & (token != nil)}.select(:id).map(&:id)
      followings.destroy_all
      au_ids.each do |au_id|
        Following.create(
            user_id: id,
            follower_id: au_id
        )
      end
    end

    def has_follower?(user)
      Following.where(follower_id: user.id, user_id: id).count > 0
    end
  end
end