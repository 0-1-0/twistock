FactoryGirl.define do
  sequence(:user_uid) {|n| n }

  factory :user do
    uid  { generate(:user_uid) }
    name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    nickname { Faker::Lorem.word }
    avatar  "TODO: correct avatar testing"
    token   'asddsadas'
    secret  'sfdasdffads'

    trait :without_creds do
      token   nil
      secret  nil
    end

    factory :user_without_creds, traits: [:without_creds]
  end
end
