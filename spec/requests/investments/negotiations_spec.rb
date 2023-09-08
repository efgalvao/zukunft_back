require 'rails_helper'

RSpec.describe 'Investments::NegotiationsController', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let(:stock) { create(:stock, account: account) }

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:negotiation_attributes) { attributes_for(:negotiation, :for_stock) }

      it 'create negotiation', :aggregate_failures do
        sign_in user
        post '/api/v1/negotiations', params: { negotiation: {
          kind: negotiation_attributes[:kind],
          date: negotiation_attributes[:date],
          value: '1.23',
          shares: negotiation_attributes[:shares],
          parent_kind: 'stock',
          parent_id: stock.id
        } }

        expect(response).to be_successful
        expect(account.reload.stocks.count).to eq(1)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['attributes']['kind']).to eq(negotiation_attributes[:kind])
        expect(parsed_response['attributes']['date']).to eq(negotiation_attributes[:date].strftime('%Y-%m-%d'))
        expect(parsed_response['attributes']['invested_cents']).to eq(123)
        expect(parsed_response['attributes']['shares']).to eq(negotiation_attributes[:shares])
      end
    end
  end
end
