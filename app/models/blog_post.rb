class BlogPost < ActiveRecord::Base
  belongs_to :user
  has_many :comments, class_name: PostComment
  
  attr_accessible :author_id, :content, :published, :title
end
