# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product_invoice do
    product ""
    country "MyString"
    postal_code "MyString"
    city "MyString"
    full_name "MyString"
    address "MyString"
    email "MyString"
    phone "MyString"
  end
end
