FactoryBot.define do
  factory :item do
    name { "Item #{Faker::Lorem.word} #{Faker::Lorem.word}" }
    description { Faker::Lorem.paragraph(sentence_count: 5) }
    unit_price { Faker::Number.number(digits: 5) }
    merchant
  end
end 