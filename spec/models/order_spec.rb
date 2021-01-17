require 'rails_helper'

RSpec.describe Order, type: :model do

  it { should belong_to(:event)}

  it { should validate_presence_of(:tickets_amount)}
  it { should validate_presence_of(:event_id)}


end
