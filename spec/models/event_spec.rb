require 'rails_helper'

RSpec.describe Event, type: :model do
  it {should have_many(:orders).dependent(:destroy)}

  it { should validate_presence_of(:name)}
  it { should validate_presence_of(:tickets_total)}
  it { should validate_presence_of(:tickets_sold)}
  it { should validate_presence_of(:ticket_price)}
  it { should validate_presence_of(:start_at)}
  it { should validate_presence_of(:end_at)}
end
