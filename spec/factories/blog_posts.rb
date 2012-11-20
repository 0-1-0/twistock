# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :blog_post do
    content "MyText"
    author_id 1
    title "MyString"
    published false
  end
end
