FactoryBot.define do
  factory :calendar_entry do
    association :villa
    date { Faker::Date.forward(days: 30) }
    price { Faker::Number.between(from: 100, to: 1000) }
    available { [true, false].sample }
  end
end