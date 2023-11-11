require 'rails_helper'

RSpec.describe 'Financings::Financings', type: :request do
  let(:user) { create(:user) }

  describe 'GET #index' do
    let!(:financing) { create(:financing, user: user) }
    let!(:another_financing) { create(:financing) }

    it 'returns a list of all financings for an user', :aggregate_failures do
      sign_in user
      get '/api/v1/financings/financings', params: { user_id: user.id }

      expect(response).to be_successful
      expect(response.body).not_to include(another_financing.name)

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).not_to eq('[]')
      expect(parsed_response[0]['id']).to eq(financing.id.to_s)
      expect(parsed_response[0]['attributes']['name']).to eq(financing.name)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:financing_attributes) { attributes_for(:financing, user: user) }

      it 'create financing', :aggregate_failures do
        sign_in user
        post '/api/v1/financings/financings', params: { financing: {
          name: financing_attributes[:name],
          user_id_id: financing_attributes[:user][:id],
          borrowed_value: (financing_attributes[:borrowed_value_cents] / 100.0),
          installments: financing_attributes[:installments]
        } }

        expect(response).to be_successful
        expect(user.reload.financings.count).to eq(1)

        parsed_response = JSON.parse(response.body)

        expect(parsed_response['name']).to eq(financing_attributes[:name])
        expect(parsed_response['borrowed_value_cents']).to eq(financing_attributes[:borrowed_value_cents])
        expect(parsed_response['installments']).to eq(financing_attributes[:installments])
      end
    end

    context 'with invalid attributes' do
      let(:financing_attributes) { attributes_for(:financing, user: user) }

      it 'does not create financing', :aggregate_failures do
        sign_in user
        post '/api/v1/financings/financings', params: { financing: {
          name: nil,
          installments: financing_attributes[:installments]
        } }

        expect(response).to be_unprocessable
        expect(user.reload.financings.count).to eq(0)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq(["Name can't be blank"])
      end
    end
  end

  describe 'GET #show' do
    let(:financing) { create(:financing, user: user) }

    it 'returns financing', :aggregate_failures do
      sign_in user
      get "/api/v1/financings/financings/#{financing.id}"

      expect(response).to be_successful

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['id']).to eq(financing.id)
      expect(parsed_response['name']).to eq(financing.name)
      expect(parsed_response['borrowed_value_cents']).to eq(financing.borrowed_value_cents)
      expect(parsed_response['installments']).to eq(financing.installments)
    end
  end
end
