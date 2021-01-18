class Order < ApplicationRecord

  belongs_to :event
  has_many :tickets

  enum status: [:open, :closed]

  validates_presence_of :tickets_amount, :event_id
  validates :tickets_amount, numericality: {greater_than: 0}
  validate :tickets_availability

  before_save :add_expiration_time, :calculate_sum, :reserve_tickets
  after_destroy :restore_reserved_tickets


  def pay(token)
    if self.open?
      if Adapters::Payment::Gateway.charge(amount: self.sum, token: token)
        if token == "expired"
          self.destroy!
        end

        if Order.exists?(self.id)
          if self.closed!
            tickets = create_tickets(self)
            return tickets
          else
            raise StandardError, "Order failed to close. During purchase something went wrong, no tickets bought, we returned you your money"
          end
        else
          raise StandardError, "Order does not exist. During purchase something went wrong, no tickets bought, we returned you your money"
        end
      else
        raise StandardError, "Payment failed"
      end
    else
      raise StandardError, "Order is already closed"
    end
  end

  def create_tickets(order)
    event = order.event
    tickets = []
    order.tickets_amount.times do
      ticket = Ticket.create(order_id: order.id, key: event.name.hash.to_s + SecureRandom.alphanumeric(5))
      tickets << ticket
    end
    tickets
  end


  def add_expiration_time
    if self.expires_at.nil?
      self.expires_at = Time.now.in(900)
    end
  end

  def calculate_sum
    if self.event_id
      event = Event.find(self.event_id)
      sum = self.tickets_amount * event.ticket_price
      self.sum = sum
    end
  end

  def reserve_tickets
    update_tickets_sold(:reserve)
  end

  def restore_reserved_tickets
    update_tickets_sold(:restore)
  end

  def update_tickets_sold(action)
    if self.event_id
      event = Event.find(self.event_id)

      case action
      when :reserve
        # to reserve tickets add to event's sold tickets
        event.tickets_sold += self.tickets_amount
      when :restore
        # to restore tickets substract from event's sold tickets
        event.tickets_sold -= self.tickets_amount
      end

      event.save
    end
  end

  def tickets_availability
    if self.tickets_amount
      if self.event_id
        event = Event.find(self.event_id)
        available_tickets = event.tickets_total - event.tickets_sold
        if self.tickets_amount > available_tickets
          errors.add(:requested_amount, "Not enough tickets (#{self.tickets_amount}). Only #{available_tickets} left")
        end
      else
        errors.add(:event, "does not exist")
        return false
      end
    end
  end
end
