require 'rails_helper'

RSpec.describe Event, type: :model do
  it {should have_many(:orders).dependent(:destroy)}

  it { should validate_presence_of(:name)}
  it { should validate_presence_of(:tickets_total)}
  it { should validate_presence_of(:start_at)}
  it { should validate_presence_of(:end_at)}

  before(:each) do
    @event = build(:event)
  end

  it 'valid with correct info' do
    expect(@event).to be_valid
  end

  it 'not valid without name' do
    @event.name = nil
    expect(@event).not_to be_valid
  end

  it 'not valid without total tickets amount' do
    @event.tickets_total = nil
    expect(@event).not_to be_valid
  end

  it 'not valid without start date' do
    @event.start_at = nil
    expect(@event).not_to be_valid
  end

  it 'not valid without end date' do
    @event.end_at = nil
    expect(@event).not_to be_valid
  end
end
