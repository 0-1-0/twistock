# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :block_of_shares, :class => 'BlockOfShares' do
    association :owner,   factory: :user
    association :holder,  factory: :user
    count { Random.rand(100) + 1 }
  end
end
