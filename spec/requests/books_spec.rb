require 'rails_helper'
require 'exceptions'
require 'support/request_spec_helper'

RSpec.describe 'Books API', type: :request do
  describe 'POST request' do
    context '/book' do
      context 'all tickets available' do
        before(:each) do
          @event = build(:event)
          @event.tickets_total = 500
          @event.tickets_sold = 200
          @event.save
          @tickets_to_buy = 10
          post "/api/v1/events/#{@event.id}/book/#{@tickets_to_buy}"
        end
        it 'respond with 200 and enough amount of tickets' do
          expect(response).to have_http_status(200)
          expect(json).not_to be_empty
          expect(json['tickets_amount']).to eq(@tickets_to_buy)
        end
        it 'decrease amount of available tickets' do
          get "/api/v1/events/#{@event.id}"
          expect(json['tickets_sold']).to eq(210)
        end
      end
      context 'not enough tickets to buy' do
        before(:each) do
          @event = build(:event)
          @event.tickets_total = 500
          @event.tickets_sold = 400
          @event.save
          @tickets_to_buy = 150
          post "/api/v1/events/#{@event.id}/book/#{@tickets_to_buy}"
        end
        it 'respond with 500' do
          expect(response).to have_http_status(500)
          expect(json).not_to be_empty
          expect(response.body).to match(/Not enough tickets \(#{@tickets_to_buy}\). Only #{100} left/)
        end
      end
      context 'event is over' do
        before(:each) do
          @event = build(:event)
          @event.end_at = Time.now
          @event.save
          post "/api/v1/events/#{@event.id}/book/#{1}"
        end
        it 'respond with 500' do
          expect(response).to have_http_status(500)
          expect(response.body).to match(/Event is over/)
        end
      end
    end
  end
end