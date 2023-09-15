FactoryBot.define do
  factory :transaction do
    credit_card_number { Faker::Number.number(digits: 16) }
    credit_card_expiration_date { "04/27" }
    result { [0, 1].sample }
    invoice
  end
end