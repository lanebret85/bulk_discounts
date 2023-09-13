FactoryBot.define do
  factory :item do
    name { "Item #{Faker::Lorem.words(number: 2)}" }
    description { Faker::Lorem.paragraph(sentence_count: 5) }
    unit_price { Faker::Number.numer(digits: 5) }
  end
end 