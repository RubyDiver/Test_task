require 'rails_helper'
require 'exceptions'
require 'support/request_spec_helper'

RSpec.describe 'Tickets API', type: :request do
  describe 'GET requests' do
    context '/tickets' do
      context 'all:' do
        before(:each) do
          event = create(:event)
          @order = build(:order)
          @order.event_id = event.id
          @order.save
        end
        context 'When tickets exist' do
          before(:each) do
            tickets = build_list(:ticket, 3)
            tickets.each do |t|
              t.order_id = @order.id
              t.save
            end
            get "/api/v1/orders/#{@order.id}/tickets"
          end
          it 'returns the list of tickets' do
            expect(response).to have_http_status(200)
            expect(json).not_to be_empty
            expect(json.length).to eq(3)
          end
        end
        context 'When there is no tickets' do
          before(:each) do
            get "/api/v1/orders/#{@order.id}/tickets"
          end
          it 'respond with 200 and is empty' do
            expect(response).to have_http_status(200)
            expect(json).to be_empty
          end
        end
      end
    end
  end
end