require 'rails_helper'

RSpec.describe Investments::Treasury::UpdateTreasury, type: :service do
  let(:treasury) { create(:treasury) }
  let(:params) { { name: 'New Name', released: true } }

  describe '#call' do
    subject(:service_call) { described_class.new(treasury_id: treasury.id, **params).call }

    context 'when the treasury exists' do
      it 'updates the treasury name' do
        expect { service_call }.to change { treasury.reload.name }.to('New Name')
      end

      it 'updates the treasury released status' do
        expect { service_call }.to change { treasury.reload.released }.to(true)
      end

      it 'does not update the treasury invested value' do
        expect { service_call }.not_to(change { treasury.reload.invested_value_cents })
      end

      it 'returns a successful result' do
        expect(service_call.valid?).to eq(true)
      end
    end

    context 'when the treasury does not exist' do
      it 'raises an ActiveRecord::RecordNotFound error' do
        expect do
          described_class.new(treasury_id: 0, **params).call
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
