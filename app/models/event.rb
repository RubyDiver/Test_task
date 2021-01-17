class Event < ApplicationRecord
  has_many :orders, dependent: :destroy

  validates_presence_of :name, :start_at, :end_at, :tickets_total, :ticket_price, :tickets_sold
end
