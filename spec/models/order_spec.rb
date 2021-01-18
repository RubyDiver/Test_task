require 'rails_helper'

RSpec.describe Order, type: :model do

  it { should belong_to(:event)}

  it { should validate_presence_of(:tickets_amount)}
  it { should validate_presence_of(:event_id)}


  before(:each) do
    event = create(:event)
    @order = build(:order)
    @order.event_id = event.id
  end

  it 'valid with correct info' do
    expect(@order).to be_valid
  end

  it 'not valid without tickets amount' do
    @order.tickets_amount = nil
    expect(@order).not_to be_valid
  end

  it 'not valid without event ID' do
    @order.event_id = nil
    expect(@order).not_to be_valid
  end

  it 'not valid when tickets amount is 0' do
    @order.tickets_amount = 0
    expect(@order).not_to be_valid
  end
end
