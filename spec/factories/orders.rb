FactoryBot.define do
  factory :order do
    tickets_amount {rand(10..100)}
    status {:open}
    event_id {nil}
  end
end