require 'rails_helper'

RSpec.describe 'Investments::Treasury::Treasuries', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }

  describe 'GET #index' do
    let!(:treasury) { create(:treasury, account: account) }
    let!(:another_account_treasury) { create(:treasury) }

    it 'returns a list of all treasuries for an account', :aggregate_failures do
      sign_in user
      get '/api/v1/investments/treasuries', params: { treasury: { account_id: account.id } }

      expect(response).to be_successful
      expect(response.body).not_to include(another_account_treasury.name)

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).not_to eq('[]')
      expect(parsed_response[0]['id']).to eq(treasury.id.to_s)
      expect(parsed_response[0]['attributes']['name']).to eq(treasury.name)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:treasury_attributes) { attributes_for(:treasury, account: account) }

      it 'create treasury', :aggregate_failures do
        sign_in user
        post '/api/v1/investments/treasuries', params: { treasury: {
          name: treasury_attributes[:name],
          account_id: treasury_attributes[:account][:id],
          invested_value_cents: treasury_attributes[:invested_value_cents],
          current_value_cents: treasury_attributes[:current_value_cents]
        } }

        expect(response).to be_successful
        expect(account.reload.treasuries.count).to eq(1)

        parsed_response = JSON.parse(response.body)

        expect(parsed_response['attributes']['account_id']).to eq(account.id)
        expect(parsed_response['attributes']['name']).to eq(treasury_attributes[:name])
        expect(parsed_response['attributes']['invested_value_cents']).to eq((treasury_attributes[:invested_value_cents] * 100).to_i)
        expect(parsed_response['attributes']['current_value_cents']).to eq((treasury_attributes[:current_value_cents] * 100).to_i)
      end
    end

    context 'with invalid attributes' do
      let(:treasury_attributes) { attributes_for(:dividend, account: account) }

      it 'does not create stock', :aggregate_failures do
        sign_in user
        post '/api/v1/investments/treasuries', params: { treasury: {
          name: nil,
          account_id: treasury_attributes[:account][:id]
        } }

        expect(response).to be_unprocessable
        expect(account.reload.treasuries.count).to eq(0)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to eq("Name can't be blank")
      end
    end
  end

  describe 'GET #show' do
    let(:treasury) { create(:treasury, account: account) }

    it 'returns treasury', :aggregate_failures do
      sign_in user
      get "/api/v1/investments/treasuries/#{treasury.id}"

      expect(response).to be_successful

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['id']).to eq(treasury.id.to_s)
      expect(parsed_response['attributes']['name']).to eq(treasury.name)
      expect(parsed_response['attributes']['account_id']).to eq(treasury.account_id)
      expect(parsed_response['attributes']['invested_value_cents']).to eq(treasury.invested_value_cents)
      expect(parsed_response['attributes']['current_value_cents']).to eq(treasury.current_value_cents)
    end
  end

  describe 'PUT #update' do
    let(:treasury) { create(:treasury, name: 'Default', account: account) }

    context 'with valid attributes' do
      it 'update treasury', :aggregate_failures do
        sign_in user
        put "/api/v1/investments/treasuries/#{treasury.id}", params: { treasury: {
          name: 'New Name'
        } }

        expect(response).to be_successful
        expect(account.reload.treasuries.count).to eq(1)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['attributes']['name']).to eq('New Name')
        expect(parsed_response['attributes']['name']).not_to eq(treasury.name)
      end
    end

    context 'with invalid attributes' do
      it 'does not update treasury', :aggregate_failures do
        sign_in user
        put "/api/v1/investments/treasuries/#{treasury.id}", params: { treasury: {
          name: nil
        } }

        expect(response).to be_unprocessable

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to eq("Name can't be blank")
      end
    end
  end

  describe 'DELETE #delete' do
    let(:treasury) { create(:treasury, name: 'Default', account: account) }

    it 'delete treasury', :aggregate_failures do
      sign_in user
      delete "/api/v1/investments/treasuries/#{treasury.id}"

      expect(response).to be_successful
      expect(account.reload.treasuries.count).to eq(0)
    end
  end
end
