class BlockOfShares < ActiveRecord::Base
  belongs_to :holder, class_name: User
  belongs_to :owner,  class_name: User

  attr_accessible :count, :holder_id, :owner_id
end
