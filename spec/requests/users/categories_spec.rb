require 'rails_helper'

RSpec.describe 'Users::CategoriesController', type: :request do
  let(:user) { create(:user) }

  describe 'GET #index' do
    let!(:category) { create(:category, user: user) }

    it 'returns a list of categories', :aggregate_failures do
      sign_in user
      get '/api/v1/categories'

      expect(response).to be_successful

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).not_to eq('[]')
      expect(parsed_response[0]['id']).to eq(category.id.to_s)
      expect(parsed_response[0]['attributes']['name']).to eq(category.name)
    end
  end

  describe 'GET #show' do
    let!(:category) { create(:category, user: user) }

    it 'returns category', :aggregate_failures do
      sign_in user
      get "/api/v1/categories/#{category.id}"

      expect(response).to be_successful

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['id']).to eq(category.id.to_s)
      expect(parsed_response['attributes']['name']).to eq(category.name)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:category_attributes) { attributes_for(:category, user: user) }

      it 'create category', :aggregate_failures do
        sign_in user
        post '/api/v1/categories', params: { category: { name: category_attributes[:name] } }

        expect(response).to be_successful
        expect(Category.count).to eq(1)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['attributes']['name']).to eq(category_attributes[:name])
      end
    end

    context 'with invalid attributes' do
      it 'does not create category', :aggregate_failures do
        sign_in user
        post '/api/v1/categories', params: { category: { name: '' } }

        expect(response).to be_unprocessable
        expect(Category.count).to eq(0)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['error']).to eq("Name can't be blank")
      end
    end
  end

  describe 'PUT #update' do
    let!(:category) { create(:category, user: user, name: 'Default') }

    context 'with valid attributes' do
      it 'update category', :aggregate_failures do
        sign_in user
        put "/api/v1/categories/#{category.id}", params: { category: { name: 'New Name' } }

        expect(response).to be_successful

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['attributes']['name']).not_to eq(category[:name])
        expect(parsed_response['attributes']['name']).to eq('New Name')
      end
    end

    context 'with invalid attributes' do
      it 'does not update category', :aggregate_failures do
        sign_in user
        put "/api/v1/categories/#{category.id}", params: { category: { name: nil } }

        expect(response).to be_unprocessable

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['error']).to eq("Name can't be blank")
      end
    end
  end

  describe 'DELETE #delete' do
    let!(:category) { create(:category, user: user) }

    it 'delete category', :aggregate_failures do
      sign_in user
      delete "/api/v1/categories/#{category.id}"

      expect(response).to be_successful
      expect(Category.count).to eq(0)
    end
  end
end
