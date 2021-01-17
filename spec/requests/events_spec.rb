require 'rails_helper'

RSpec.describe 'Events API', type: :request do
  describe 'GET requests' do
    context '/events' do
      context 'all:' do
        context 'When a few events exist' do
          before(:each) do
            @events = create_list(:event, 10)
            get "/api/v1/events"
          end
          it 'respond with 200 and enought amount of events' do
            expect(response).to have_http_status(200)
            expect(json).not_to be_empty
            expect(json.length).to eq(@events.length)
          end
        end

        context 'When there is no events' do
          before(:each) do
            get "/api/v1/events"
          end
          it 'respond with 200 and is empty' do
            expect(response).to have_http_status(200)
            expect(json).to be_empty
          end
        end
      end

      context 'one:' do
        context 'When the event exist' do
          before(:each) do
            @event = create(:event)
            get "/api/v1/events/#{@event.id}/"
          end
          it 'respond with 200 and valid attr' do
            expect(response).to have_http_status(200)
            expect(json).not_to be_empty
            expect(json['id']).to eq(@event.id)
            expect(json['ticket_total']).to eq(@event.tickets_total)
          end
        end

        context 'When the event does not exist' do
          before(:each) do
            get "/api/v1/events/1"
          end
          it 'respond with 404' do
            expect(response).to have_http_status(404)
          end
        end
      end
    end
  end
end