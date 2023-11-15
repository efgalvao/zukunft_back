require 'rails_helper'

RSpec.describe 'Financings::Installments', type: :request do
  let(:user) { create(:user) }
  let(:financing) { create(:financing, user: user) }

  describe 'POST #create' do
    let(:payment_attributes) { attributes_for(:payment, financing: financing) }

    context 'with valid attributes' do
      it 'create payment', :aggregate_failures do
        sign_in user
        post '/api/v1/financings/installments', params: { installment: {
          financing_id: financing.id,
          ordinary: payment_attributes[:ordinary],
          parcel: payment_attributes[:parcel],
          paid_parcels: payment_attributes[:paid_parcels],
          payment_date: payment_attributes[:payment_date],
          amortization: (payment_attributes[:amortization_cents].to_f / 100.0),
          interest: payment_attributes[:interest_cents].to_f / 100.0,
          insurance: payment_attributes[:insurance_cents].to_f / 100.0,
          fees: payment_attributes[:fees_cents].to_f / 100.0,
          monetary_correction: payment_attributes[:monetary_correction_cents].to_f / 100.0,
          adjustment: payment_attributes[:adjustment_cents].to_f / 100.0
        } }

        expect(response).to be_successful
        expect(user.reload.financings.count).to eq(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not create stock', :aggregate_failures do
        sign_in user
        post '/api/v1/financings/installments', params: { installment: {
          ordinary: payment_attributes[:ordinary],
          parcel: payment_attributes[:parcel],
          paid_parcels: payment_attributes[:paid_parcels],
          payment_date: payment_attributes[:payment_date],
          amortization: (payment_attributes[:amortization_cents].to_f / 100.0),
          interest: payment_attributes[:interest_cents].to_f / 100.0,
          insurance: payment_attributes[:insurance_cents].to_f / 100.0,
          fees: payment_attributes[:fees_cents].to_f / 100.0,
          monetary_correction: payment_attributes[:monetary_correction_cents].to_f / 100.0,
          adjustment: payment_attributes[:adjustment_cents].to_f / 100.0
        } }

        expect(response).to be_unprocessable
      end
    end
  end
end
