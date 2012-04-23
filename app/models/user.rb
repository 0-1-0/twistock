class User < ActiveRecord::Base
  attr_accessible :avatar, :money, :name, :nickname, :uid

  def self.create_from_twitter(auth)
    User.create(  uid:      auth.uid.to_i,
                  name:     auth.info.name,
                  nickname: auth.info.nickname,
                  avatar:   auth.info.image,
                  money:    1000
                )
  end

  def self.try_to_find(uid)
    User.where(uid: uid).first
  end
end