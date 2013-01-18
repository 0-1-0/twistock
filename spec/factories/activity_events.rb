# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity_event do
    user nil
    price_change 1
    source nil
  end
end
