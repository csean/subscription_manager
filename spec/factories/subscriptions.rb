FactoryBot.define do
  factory :subscription do
    cc_number { CreditCardValidations::Factory.random(:amex) }
    cvv { Faker::Number.number(4) }
    expiration_month { 1 + rand(12) }
    expiration_year { Date.today.year + 1 }
    subscriber
    item
  end
end
