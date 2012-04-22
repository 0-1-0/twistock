class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :uid, :type => Integer
  field :name, :type => String
  field :nickname, :type => String
  field :avatar, :type => String

  key :uid

  index :uid,
    unique: true,
    background: true
  index :name,
    background: true
  index :nickname, 
    background: true

  def self.create_from_twitter(auth)
    User.create(  uid:      auth.uid.to_i,
                  name:     auth.info.name,
                  nickname: auth.info.nickname,
                  avatar:   auth.info.image
                )
  end

  def self.try_to_find(uid)
    User.where(uid: uid).first
  end
end
