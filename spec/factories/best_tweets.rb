FactoryGirl.define do
  sequence(:best_tweet_id) {|n| n }

  factory :best_tweet do
    association :user, factory: user
    twitter_id { generate(:best_tweet_id) }
    media_url nil
    retweets { Random.rand(100) }
    content { Faker::Lorem.paragraph }
    param { Random.rand }
  end
end
