require 'rails_helper'

RSpec.describe 'Accounts', type: :request do
  describe 'request list of all accounts' do
    let(:user) { create(:user) }
    let!(:account) { create(:account, user: user) }

    it 'returns a list of all accounts', :aggregate_failures do
      sign_in user
      get '/api/v1/accounts'

      expect(response).to be_successful
      expect(response.body).not_to eq('[]')
      expect(response.body).to include(account.id.to_s)
      expect(response.body).to include(account.name)
    end
  end

  describe 'request an account' do
    let(:user) { create(:user) }
    let(:account) { create(:account, user: user) }

    it 'returns account', :aggregate_failures do
      sign_in user
      get "/api/v1/accounts/#{account.id}"

      expect(response).to be_successful
      expect(response.body).not_to eq('[]')
      expect(response.body).to include(account.id.to_s)
      expect(response.body).to include(account.name)
    end
  end

  describe 'create account' do
    let(:user) { create(:user) }
    let(:account) { attributes_for(:account, user: user) }

    it 'returns account', :aggregate_failures do
      sign_in user
      post '/api/v1/accounts', params: { account: account }

      expect(response).to be_successful
      expect(response.body).not_to eq('[]')
      expect(response.body).to include(account[:name])
    end
  end
end
