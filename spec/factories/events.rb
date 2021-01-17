FactoryBot.define do
  factory :event do
    name {Faker::Lorem.word}
    tickets_total {rand(100..2000)}
    tickets_sold {0}
    ticket_price {rand(1..1000)}
    start_at {@start_date = Time.now.in(rand(-10800..600000))}
    end_at {@start_date.in(rand(1800..10800))}
  end
end