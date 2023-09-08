require 'rails_helper'

RSpec.describe 'Users::TransferencesController', type: :request do
  let(:user) { create(:user) }
  let!(:sender_account) { create(:account, user: user) }
  let!(:receiver_account) { create(:account, user: user) }

  describe 'request list of all transferences' do
    let!(:transference) do
      create(:transference,
             user: user,
             sender_id: sender_account.id,
             receiver_id: receiver_account.id)
    end

    it 'GET #index', :aggregate_failures do
      sign_in user
      get '/api/v1/transferences'

      expect(response).to be_successful

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).not_to eq('[]')
      expect(parsed_response[0]['id']).to eq(transference.id.to_s)
      expect(parsed_response[0]['attributes']['sender_id']).to eq(sender_account.id)
      expect(parsed_response[0]['attributes']['receiver_id']).to eq(receiver_account.id)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:sender_account) { create(:account, user: user) }
      let(:receiver_account) { create(:account, user: user) }
      let(:transference_attributes) do
        {
          sender: sender_account.id,
          receiver: receiver_account.id,
          user: user,
          value: 123,
          date: Time.zone.today
        }
      end

      it 'create transference', :aggregate_failures do
        sign_in user
        post '/api/v1/transferences', params: { transference: transference_attributes }
        expect(response).to be_successful
        expect(Transference.count).to eq(1)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['attributes']['sender_id']).to eq(sender_account.id)
        expect(parsed_response['attributes']['receiver_id']).to eq(receiver_account.id)
      end
    end

    context 'with invalid attributes', :aggregate_failures do
      let(:sender_account) { create(:account, user: user) }
      let(:transference_attributes) do
        {
          sender: sender_account.id,
          receiver: sender_account.id,
          user: user,
          value: 123,
          date: Time.zone.today
        }
      end

      it 'does not create transference', :aggregate_failures do
        sign_in user
        post '/api/v1/transferences', params: { transference: transference_attributes }
        expect(response).to be_unprocessable
        expect(Transference.count).to eq(0)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq({ 'base' => ['Accounts must be different'] })
      end
    end
  end
end
