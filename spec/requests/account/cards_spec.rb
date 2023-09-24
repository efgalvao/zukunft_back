require 'rails_helper'

RSpec.describe 'Card Accounts', type: :request do
  let(:user) { create(:user) }
  let!(:card_account) { create(:account, :card, user: user) }

  describe 'request list of all accounts' do
    let!(:savings_account) { create(:account, user: user) }

    it 'returns a list of all card accounts', :aggregate_failures do
      sign_in user
      get '/api/v1/cards'

      expect(response).to be_successful
      expect(response.body).not_to include(savings_account.name)

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).not_to eq('[]')
      expect(parsed_response[0]['id']).to eq(card_account.id.to_s)
      expect(parsed_response[0]['attributes']['name']).to eq(card_account.name)
    end
  end

  describe 'request an account' do
    let(:user) { create(:user) }

    it 'returns account', :aggregate_failures do
      sign_in user
      get "/api/v1/cards/#{card_account.id}"

      expect(response).to be_successful

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['id']).to eq(card_account.id.to_s)
      expect(parsed_response['attributes']['name']).to eq(card_account.name)
    end
  end

  describe 'create card' do
    let(:user) { create(:user) }

    context 'with valid attributes' do
      let(:card_account) { attributes_for(:account, :card, user: user) }
      let(:balance) { '1000.01' }

      it 'create card', :aggregate_failures do
        sign_in user
        post '/api/v1/cards', params: { card: { name: card_account[:name], balance: balance } }

        expect(response).to be_successful

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['attributes']['name']).to eq(card_account[:name])
        expect(parsed_response['attributes']['balance_cents']).to eq(balance.to_f * 100)
      end
    end

    context 'with invalid attributes' do
      let(:card_account) { attributes_for(:account, :card, user: user, name: '') }

      it 'create card', :aggregate_failures do
        sign_in user
        post '/api/v1/cards', params: { card: { name: card_account[:name], balance_cents: card_account[:balance_cents] } }

        expect(response).to be_unprocessable

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['name']).to eq(["can't be blank"])
      end
    end
  end

  describe 'update card' do
    let(:user) { create(:user) }

    context 'with valid attributes' do
      let!(:card_account) { create(:account, :card, user: user, name: 'Default') }

      it 'update account', :aggregate_failures do
        sign_in user
        put "/api/v1/cards/#{card_account.id}", params: { card: { name: 'New Name' } }

        expect(response).to be_successful

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['attributes']['name']).not_to eq(card_account[:name])
        expect(parsed_response['attributes']['name']).to eq('New Name')
        expect(parsed_response['attributes']['balance_cents']).to eq(card_account[:balance_cents])
      end
    end

    context 'with invalid attributes' do
      let!(:card_account) { create(:account, :card, user: user, name: 'Default') }

      it 'update account', :aggregate_failures do
        sign_in user
        put "/api/v1/cards/#{card_account.id}", params: { card: { name: nil } }

        expect(response).to be_unprocessable

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['name']).to eq(["can't be blank"])
      end
    end
  end

  describe 'delete card' do
    let(:user) { create(:user) }

    let!(:card_account) { create(:account, :card, user: user) }

    it 'delete account', :aggregate_failures do
      sign_in user
      delete "/api/v1/cards/#{card_account.id}"

      expect(response).to be_successful
      expect(Account::Account.count).to eq(0)
    end
  end
end
