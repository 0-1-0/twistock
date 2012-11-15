class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :owner, class_name: User

  attr_accessible :action, :cost, :count, :owner, :user, :price

  delegate :nickname, to: :user,  prefix: true
  delegate :nickname, to: :owner, prefix: true
end
