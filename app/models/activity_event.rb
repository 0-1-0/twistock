class ActivityEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :source, polymorphic: true
  attr_accessible :price_change
end
