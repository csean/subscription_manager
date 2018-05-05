FactoryBot.define do
  factory :subscriber do
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
