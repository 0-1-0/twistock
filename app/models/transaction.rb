class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :owner, class_name: User

  attr_accessible :action, :cost, :count, :owner, :user, :price

  delegate :nickname, to: :user,  prefix: true
  delegate :nickname, to: :owner, prefix: true

  # TODO: вот тут будет прикольно сбрасывать кэши цен
  # TODO: покупку и продажу можно вложить в этот класс (подумать, может удобнее)
end
