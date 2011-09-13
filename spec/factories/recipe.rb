FactoryGirl.define do
  factory :recipe do
    name { Faker::Lorem.sentence(rand(5) + 4) }
    directions { Faker::Lorem.paragraphs(rand(5) + 2).join('\n\n') }
    cook_time { rand(90) + 1 }
    category
    author :factory => :user
    photo_file_name { Faker::Lorem.sentence.parameterize }
    num_persons { rand(10) + 1 }
  end
end
