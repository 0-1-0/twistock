# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :block_of_share, :class => 'BlockOfShares' do
    owner_id 1
    holder_id 1
    count 1
  end
end
