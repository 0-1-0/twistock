# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    tag "MyString"
    content "MyText"
  end
end
