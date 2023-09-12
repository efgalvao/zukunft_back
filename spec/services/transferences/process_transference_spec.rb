require 'rails_helper'

RSpec.describe Transferences::ProcessTransference, type: :service do
  context 'with valid attributes' do
    subject(:service) { described_class.call(params) }

    let(:user) { create(:user) }
    let!(:sender) { create(:account, user: user) }
    let!(:receiver) { create(:account, user: user) }

    let(:value) { '1.23' }
    let(:params) do
      {
        receiver_id: receiver.id,
        sender_id: sender.id,
        user_id: user.id,
        date: Date.current,
        value: value
      }
    end

    it 'create transactions', :aggregate_failures do
      expect { service }.to change(Account::Transaction, :count).by(2)

      expect(sender.transactions.last.value_cents).to eq((value.to_f * 100).to_i)
      expect(sender.transactions.last.kind).to eq('transfer')
      expect(receiver.transactions.last.value_cents).to eq((value.to_f * 100).to_i)
      expect(receiver.transactions.last.kind).to eq('transfer')
    end
  end
end
