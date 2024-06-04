require 'faker'

50.times do
  villa = Villa.create(
    name: Faker::Address.unique.community,
    description: Faker::Lorem.paragraph(sentence_count: 2),
    guest: rand(1..10)
  )

  (Date.new(2024, 1, 1)..Date.new(2024, 12, 31)).each do |date|
    villa.calendar_entries.create(
      date: date,
      price: rand(30000..50000),
      available: [true, false].sample
    )
  end
end
