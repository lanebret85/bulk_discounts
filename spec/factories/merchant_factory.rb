FactoryBot.define do
  factory :merchant do
    name { Faker::Company.name }
    status { "enabled" }
  end
end