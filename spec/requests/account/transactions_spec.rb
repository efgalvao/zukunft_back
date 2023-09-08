require 'rails_helper'

RSpec.describe 'Users::TransactionsController', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }

  describe 'GET #index' do
    let!(:transaction) { create(:transaction, account: account) }

    it 'returns a list of transactions', :aggregate_failures do
      sign_in user
      get "/api/v1/accounts/#{account.id}/transactions"

      expect(response).to be_successful

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).not_to eq('[]')
      expect(parsed_response[0]['id']).to eq(transaction.id.to_s)
      expect(parsed_response[0]['attributes']['title']).to eq(transaction.title)
      expect(parsed_response[0]['attributes']['value_cents']).to eq(transaction.value_cents)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:transaction_attributes) do
        attributes_for(:transaction, value_cents: '10.00', account: account)
      end

      it 'create transaction', :aggregate_failures do
        sign_in user
        post "/api/v1/accounts/#{account.id}/transactions", params: { transaction: {
          title: transaction_attributes[:title],
          category_id: transaction_attributes[:category_id],
          kind: transaction_attributes[:kind],
          value: transaction_attributes[:value_cents],
          date: transaction_attributes[:date],
          account_id: account.id
        } }

        expect(response).to be_successful
        expect(Account::Transaction.count).to eq(1)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['attributes']['title']).to eq(transaction_attributes[:title])
        expect(parsed_response['attributes']['value_cents'])
          .to eq(transaction_attributes[:value_cents].to_f * 100)
      end
    end

    context 'with invalid attributes' do
      let(:transaction_attributes) do
        attributes_for(:transaction, value_cents: '10.00', account: account)
      end

      it 'does not create transaction', :aggregate_failures do
        sign_in user
        post "/api/v1/accounts/#{account.id}/transactions", params: { transaction: {
          category_id: transaction_attributes[:category_id],
          kind: transaction_attributes[:kind],
          value: transaction_attributes[:value_cents],
          date: transaction_attributes[:date],
          account_id: account.id
        } }

        expect(response).to be_unprocessable
        expect(Account::Transaction.count).to eq(0)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['error']).to eq("Title can't be blank")
      end
    end
  end

  describe 'PUT #update' do
    let!(:transaction) { create(:transaction, account: account, title: 'Default') }

    context 'with valid attributes' do
      it 'update transaction', :aggregate_failures do
        sign_in user
        put "/api/v1/accounts/#{account.id}/transactions/#{transaction.id}", params: { transaction: {
          title: 'New Title'
        } }
        expect(response).to be_successful

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['attributes']['title']).not_to eq(transaction.title)
        expect(parsed_response['attributes']['title']).to eq('New Title')
      end
    end

    context 'with invalid attributes' do
      it 'does not update transaction', :aggregate_failures do
        sign_in user
        put "/api/v1/accounts/#{account.id}/transactions/#{transaction.id}", params: { transaction: {
          title: nil
        } }
        expect(response).to be_unprocessable

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['error']).to eq("Title can't be blank")
      end
    end
  end
end
