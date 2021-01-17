class Order < ApplicationRecord

  belongs_to :event

  validates_presence_of :tickets_amount, :event_id
end
