class PostComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :blog_post
  attr_accessible :content
end
