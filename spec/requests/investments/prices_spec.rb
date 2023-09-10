require 'rails_helper'

RSpec.describe 'Investments::PricesController', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let(:stock) { create(:stock, account: account) }

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:price_attributes) { attributes_for(:price, :for_stock) }

      it 'create price', :aggregate_failures do
        sign_in user
        post '/api/v1/prices', params: { price: {
          date: price_attributes[:date],
          value: '1.23',
          parent_kind: 'stock',
          parent_id: stock.id
        } }

        expect(response).to be_successful
        expect(account.reload.stocks.count).to eq(1)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['status']).to eq('created')
      end
    end

    context 'with invalid attributes' do
      let(:price_attributes) { attributes_for(:price, :for_stock) }

      before { allow(Investments::CreatePrice).to receive(:call).and_raise(StandardError) }

      it 'create price', :aggregate_failures do
        sign_in user
        post '/api/v1/prices', params: { price: {
          date: price_attributes[:date],
          value: '1.23',
          parent_kind: 'stock',
          parent_id: stock.id
        } }

        expect(response).to be_unprocessable

        parsed_response = JSON.parse(response.body)

        expect(parsed_response['status']).to eq('error')
      end
    end
  end
end
