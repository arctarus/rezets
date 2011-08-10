Factory.define :user do |user|
  user.name { Faker::Name.name }
  user.email { Faker::Internet.email }
  user.password "123456"
  user.password_confirmation "123456"
  user.slug {|u| u.name.parameterize }
end
