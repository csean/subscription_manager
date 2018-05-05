FactoryBot.define do
  factory :item do
    name { Faker::Name.name }
    price_cents { Faker::Number.number(5) }
  end
end
