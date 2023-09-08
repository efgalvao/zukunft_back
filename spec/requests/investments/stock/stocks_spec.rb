require 'rails_helper'

RSpec.describe 'Investments::Stock::StocksController', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }

  describe 'GET #index' do
    let!(:stock) { create(:stock, account: account) }
    let!(:another_account_stock) { create(:stock) }

    it 'returns a list of all stocks for an account', :aggregate_failures do
      sign_in user
      get '/api/v1/investments/stocks', params: { stock: { account_id: account.id } }

      expect(response).to be_successful
      expect(response.body).not_to include(another_account_stock.ticker)

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).not_to eq('[]')
      expect(parsed_response[0]['id']).to eq(stock.id.to_s)
      expect(parsed_response[0]['attributes']['ticker']).to eq(stock.ticker)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:stock_attributes) { attributes_for(:stock, account: account) }

      it 'create stock', :aggregate_failures do
        sign_in user
        post '/api/v1/investments/stocks', params: { stock: {
          ticker: stock_attributes[:ticker],
          account_id: stock_attributes[:account][:id],
          invested_value_cents: stock_attributes[:invested_value_cents],
          current_value_cents: stock_attributes[:current_value_cents],
          current_total_value_cents: stock_attributes[:current_total_value_cents],
          shares_total: stock_attributes[:shares_total]
        } }

        expect(response).to be_successful
        expect(account.reload.stocks.count).to eq(1)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['attributes']['account_id']).to eq(account.id)
        expect(parsed_response['attributes']['ticker']).to eq(stock_attributes[:ticker])
        expect(parsed_response['attributes']['invested_value_cents']).to eq(stock_attributes[:invested_value_cents])
        expect(parsed_response['attributes']['current_value_cents']).to eq(stock_attributes[:current_value_cents])
        expect(parsed_response['attributes']['current_total_value_cents']).to eq(stock_attributes[:current_total_value_cents])
        expect(parsed_response['attributes']['shares_total']).to eq(stock_attributes[:shares_total])
      end
    end

    context 'with invalid attributes' do
      let(:stock_attributes) { attributes_for(:dividend, account: account) }

      it 'does not create stock', :aggregate_failures do
        sign_in user
        post '/api/v1/investments/stocks', params: { stock: {
          ticker: nil,
          account_id: stock_attributes[:account][:id]
        } }

        expect(response).to be_unprocessable
        expect(account.reload.stocks.count).to eq(0)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to eq("Ticker can't be blank")
      end
    end
  end

  describe 'GET #show' do
    let(:stock) { create(:stock, account: account) }

    it 'returns stock', :aggregate_failures do
      sign_in user
      get "/api/v1/investments/stocks/#{stock.id}"

      expect(response).to be_successful

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['id']).to eq(stock.id.to_s)
      expect(parsed_response['attributes']['ticker']).to eq(stock.ticker)
      expect(parsed_response['attributes']['account_id']).to eq(stock.account_id)
      expect(parsed_response['attributes']['invested_value_cents']).to eq(stock.invested_value_cents)
      expect(parsed_response['attributes']['current_value_cents']).to eq(stock.current_value_cents)
      expect(parsed_response['attributes']['current_total_value_cents']).to eq(stock.current_total_value_cents)
      expect(parsed_response['attributes']['shares_total']).to eq(stock.shares_total)
    end
  end

  describe 'PUT #update' do
    let(:stock) { create(:stock, ticker: 'Default', account: account) }

    context 'with valid attributes' do
      it 'update stock', :aggregate_failures do
        sign_in user
        put "/api/v1/investments/stocks/#{stock.id}", params: { stock: {
          ticker: 'New Ticker'
        } }

        expect(response).to be_successful
        expect(account.reload.stocks.count).to eq(1)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['attributes']['ticker']).to eq('New Ticker')
        expect(parsed_response['attributes']['ticker']).not_to eq(stock.ticker)
      end
    end

    context 'with invalid attributes' do
      it 'does not update stock', :aggregate_failures do
        sign_in user
        put "/api/v1/investments/stocks/#{stock.id}", params: { stock: {
          ticker: nil
        } }

        expect(response).to be_unprocessable

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to eq("Ticker can't be blank")
      end
    end
  end

  describe 'DELETE #delete' do
    let(:stock) { create(:stock, ticker: 'Default', account: account) }

    it 'delete stock', :aggregate_failures do
      sign_in user
      delete "/api/v1/investments/stocks/#{stock.id}"

      expect(response).to be_successful
      expect(account.reload.stocks.count).to eq(0)
    end
  end
end
