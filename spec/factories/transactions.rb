# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    user_id 1
    action "MyString"
    owner_id 1
    count 1
    cost 1
  end
end
