Factory.define :invitation do |i|
  i.email { Faker::Internet.email }
end
