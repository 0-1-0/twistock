# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :main_page_stream do
    eng_name ""
    ru_name ""
    list_of_users ""
    eng_tooltip ""
    tu_tooltip ""
    priority 1
  end
end
