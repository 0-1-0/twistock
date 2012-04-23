class User < ActiveRecord::Base
  attr_accessible :avatar, :money, :name, :nickname, :uid

  def to_param
    nickname
  end

  def self.create_from_twitter_oauth(auth)
    User.create(  uid:      auth.uid.to_i,
                  name:     auth.info.name,
                  nickname: auth.info.nickname,
                  avatar:   auth.info.image,
                  money:    1000
                )
  end

  def self.create_from_twitter(nickname)
    begin
      info = Twitter.user(nickname)
    rescue
      return nil
    end
    User.create(  uid:      info.id,
                  name:     info.name,
                  nickname: info.screen_name,
                  avatar:   info.profile_image_url,
                  money:    1000
                )
  end

  def self.try_to_find(uid)
    User.where(uid: uid).first
  end
end