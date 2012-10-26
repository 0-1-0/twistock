FactoryGirl.define do
  sequence(:user_uid)       {|n| n }
  sequence(:user_nickname)  {|n| Faker::Lorem.word + n.to_s }

  factory :user do
    uid  { generate(:user_uid) }
    name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    nickname { generate(:user_nickname) }
    avatar  "TODO: correct avatar testing"
    token   'asddsadas'
    secret  'sfdasdffads'

    trait :without_creds do
      token   nil
      secret  nil
    end

    trait :with_base_price_and_money do
      base_price { Random.rand(100) + 1 }
      share_price { base_price }
      money 1000000
      retention_done true
    end

    factory :user_without_creds, traits: [:without_creds]
    factory :user_with_base_price_and_money, traits: [:with_base_price_and_money]
  end
end
