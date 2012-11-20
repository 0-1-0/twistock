# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post_comment do
    content "MyText"
    user nil
    blog_post nil
  end
end
