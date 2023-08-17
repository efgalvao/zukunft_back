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
end
