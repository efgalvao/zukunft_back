require 'rails_helper'

RSpec.describe 'Users::CategoriesController', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let(:stock) { create(:stock, account: account) }

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:dividend_attributes) { attributes_for(:dividend, stock: stock) }

      it 'create category', :aggregate_failures do
        sign_in user
        post '/api/v1/dividends', params: { dividend: {
          date: dividend_attributes[:date],
          value: dividend_attributes[:value_cents],
          stock_id: dividend_attributes[:stock][:id]
        } }

        expect(response).to be_successful
        expect(stock.reload.dividends.count).to eq(1)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['attributes']['stock_id']).to eq(stock.id)
        expect(parsed_response['attributes']['value_cents']).to eq((dividend_attributes[:value_cents] * 100).to_i)
      end
    end

    context 'with invalid attributes' do
      let(:dividend_attributes) { attributes_for(:dividend, stock: stock) }

      it 'create category', :aggregate_failures do
        sign_in user
        post '/api/v1/dividends', params: { dividend: {
          date: dividend_attributes[:date],
          value: dividend_attributes[:value_cents],
          stock_id: nil
        } }

        expect(response).to be_unprocessable
        expect(stock.reload.dividends.count).to eq(0)

        parsed_response = JSON.parse(response.body)
        puts parsed_response
        expect(parsed_response['errors']).to eq('Stock must exist')
      end
    end
  end
end
