# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password "123456"
    password_confirmation "123456"
    slug {|u| u.name.parameterize }
  end
end
