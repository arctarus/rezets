# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    email { Faker::Internet.email }
  end
end
