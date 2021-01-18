require 'rails_helper'
require 'exceptions'
require 'support/request_spec_helper'

RSpec.describe 'Pays API', type: :request do
  describe 'POST request' do
    context '/pay' do
      before(:each) do
        event = build(:event)
        event.save
        post "/api/v1/events/#{event.id}/book/#{2}"
        @order = json
      end
      context 'succeeded' do
        before(:each) do
          post "/api/v1/orders/#{@order['id']}/pay/ok"
        end
        it 'respond with 200, requested amount of tickets and order closed' do
          expect(response).to have_http_status(200)
          expect(json).not_to be_empty
          expect(json.length).to eq(@order['tickets_amount'])

          order = Order.find(@order['id'])
          expect(order.status).to eq('closed')
        end
      end
      context 'succeeded, but order expired due to payment delay' do
        before(:each) do
          post "/api/v1/orders/#{@order['id']}/pay/expired"
        end
        it 'respond with 500 and proper message' do
          expect(response).to have_http_status(500)
          expect(response.body).to match(/ey/)
        end
      end
      context 'failed' do
        context 'order is closed' do
          before(:each) do
            order = Order.find(@order['id'])
            order.closed!
            post "/api/v1/orders/#{@order['id']}/pay/ok"
          end
          it 'respond with 500 and proper message' do
            expect(response).to have_http_status(500)
            expect(response.body).to match(/Order is already closed/)
          end
        end
        context 'reservation expired / no such order' do
          before(:each) do
            post "/api/v1/orders/#{2}/pay/ok"
          end
          it 'respond with 404' do
            expect(response).to have_http_status(404)
          end
        end
        context 'payment failed' do
          before(:each) do
            Order.find(@order['id']).open!
          end
          context 'due to card error' do
            it 'respond with 500 and proper error message' do
              post "/api/v1/orders/#{@order['id']}/pay/card_error"
              expect(response).to have_http_status(500)
              expect(response.body).to match(/Your card has been declined/)
            end
          end
          context 'due to payment error' do
            it 'respond with 500 and proper error message' do
              post "/api/v1/orders/#{@order['id']}/pay/payment_error"
              expect(response).to have_http_status(500)
              expect(response.body).to match(/Something went wrong with your transaction/)
            end
          end
        end
      end
    end
  end
end