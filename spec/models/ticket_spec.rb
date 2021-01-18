require 'rails_helper'

RSpec.describe Ticket, type: :model do
  before(:each) do
    event = create(:event)
    order = build(:order)
    order.event_id = event.id
    order.save
    @ticket = build(:ticket)
    @ticket.order_id = order.id
  end

  it 'valid with correct info' do
    expect(@ticket).to be_valid
  end

  it 'not valid without order ID' do
    @ticket.order_id = nil
    expect(@ticket).not_to be_valid
  end

  it 'not valid without key' do
    @ticket.key = nil
    expect(@ticket).not_to be_valid
  end
end
