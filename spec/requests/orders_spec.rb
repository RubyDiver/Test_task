require 'rails_helper'
require 'exceptions'
require 'support/request_spec_helper'

RSpec.describe 'Orders API', type: :request do
  describe 'GET requests' do
    context '/orders' do
      context 'all:' do
        it 'responds with 406' do
          get "/api/v1/orders/"
          expect(response).to have_http_status(406)
        end
      end

      context 'one:' do
        context 'When the order exists' do
          before(:each) do
            @order = build(:order)
            @event = create(:event)
            @order.event_id = @event.id
            @order.save
            get "/api/v1/orders/#{@order.id}/"
          end
          it 'respond with 200 and valid attr' do
            expect(response).to have_http_status(200)
            expect(json).not_to be_empty
            expect(json['id']).to eq(@order.id)
            expect(json['status']).to eq('open')
            expect(json['event_id']).to eq(@event.id)
            expect(json['tickets_amount']).to eq(@order.tickets_amount)
            expect(json['expires_at']).to eq(JSON.parse(@order.expires_at.to_json))
          end
          it 'expires in less than 15 minutes' do
            expires_at = Time.zone.parse(json['expires_at'])
            time_left = expires_at - Time.now
            expect(time_left > 0 && time_left < 900).to eq true
          end
        end

        context 'Order does not exist' do
          before(:each) do
            get "/api/v1/orders/1"
          end
          it 'respond with 404' do
            expect(response).to have_http_status(404)
          end
        end
      end
    end
  end
end