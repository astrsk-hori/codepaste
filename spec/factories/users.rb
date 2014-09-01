# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:id){|n| n}
    email "test@example.com"
    name "name"
    password "password"
  end
end
