require 'rails_helper'

RSpec.describe 'Account::AccountsController', type: :request do
  let(:user) { create(:user) }
  let!(:account) { create(:account, user: user) }

  describe 'GET #index' do
    let!(:card_account) { create(:account, :card, user: user) }

    it 'returns a list of all accounts exceptd card kind', :aggregate_failures do
      sign_in user
      get '/api/v1/accounts'

      expect(response).to be_successful
      expect(response.body).not_to include(card_account.name)

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).not_to eq('[]')
      expect(parsed_response[0]['id']).to eq(account.id.to_s)
      expect(parsed_response[0]['attributes']['name']).to eq(account.name)
    end
  end

  describe 'GET #show' do
    it 'returns account', :aggregate_failures do
      sign_in user
      get "/api/v1/accounts/#{account.id}"

      expect(response).to be_successful

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['id']).to eq(account.id.to_s)
      expect(parsed_response['attributes']['name']).to eq(account.name)
    end
  end

  describe 'GET #brokers' do
    let!(:broker_account) { create(:account, :broker, user: user) }

    it 'returns brokers accounts', :aggregate_failures do
      sign_in user
      get '/api/v1/brokers'

      expect(response).to be_successful
      expect(response.body).not_to include(account.name)

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).not_to eq('[]')
      expect(parsed_response[0]['id']).to eq(broker_account.id.to_s)
      expect(parsed_response[0]['attributes']['name']).to eq(broker_account.name)
    end
  end

  describe 'create account' do
    context 'with valid attributes' do
      let(:account_attributes) { attributes_for(:account, user: user) }
      let(:balance) { '1000.01' }

      it 'create card', :aggregate_failures do
        sign_in user
        post '/api/v1/accounts', params: { account: { name: account_attributes[:name],
                                                      balance: balance } }

        expect(response).to be_successful

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['attributes']['name']).to eq(account_attributes[:name])
        expect(parsed_response['attributes']['balance_cents']).to eq(balance.to_f * 100)
      end
    end

    context 'with invalid attributes' do
      let(:account_attributes) { attributes_for(:account, user: user, name: '') }
      let(:balance) { '1000.01' }

      it 'create card', :aggregate_failures do
        sign_in user
        post '/api/v1/accounts', params: { account: { name: account_attributes[:name],
                                                      balance: balance } }

        expect(response).to be_unprocessable

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['name']).to eq(["can't be blank"])
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      let!(:account) { create(:account, user: user, name: 'Default') }

      it 'update account', :aggregate_failures do
        sign_in user
        put "/api/v1/accounts/#{account.id}", params: { account: { name: 'New Name',
                                                                   kind: account.kind } }

        expect(response).to be_successful

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['attributes']['name']).not_to eq(account[:name])
        expect(parsed_response['attributes']['name']).to eq('New Name')
        expect(parsed_response['attributes']['balance_cents']).to eq(account[:balance_cents])
      end
    end

    context 'with invalid attributes' do
      let!(:account) { create(:account, user: user, name: 'Default') }

      it 'update account', :aggregate_failures do
        sign_in user
        put "/api/v1/accounts/#{account.id}", params: { account: { name: nil } }

        expect(response).to be_unprocessable

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['name']).to eq(["can't be blank"])
      end
    end
  end

  describe 'DELETE #delete' do
    let!(:account) { create(:account, user: user) }

    it 'delete account', :aggregate_failures do
      sign_in user
      delete "/api/v1/accounts/#{account.id}"

      expect(response).to be_successful
      expect(Account::Account.count).to eq(0)
    end
  end
end
