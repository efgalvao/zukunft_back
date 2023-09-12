require 'rails_helper'

RSpec.describe Transferences::CreateTransference, type: :service do
  context 'with valid attributes' do
    subject(:service) { described_class.call(params) }

    let(:user) { create(:user) }
    let!(:sender) { create(:account, user: user) }
    let!(:receiver) { create(:account, user: user) }

    let(:value) { '1.23' }

    let(:params) do
      {
        receiver: receiver.id,
        sender: sender.id,
        user_id: user.id,
        date: Date.current,
        value: value
      }
    end

    it 'create transference', :aggregate_failures do
      expect { service }.to change(Transference, :count).by(1)

      expect(user.transferences.last.value_cents).to eq((value.to_f * 100).to_i)
      expect(user.transferences.last.sender_id).to eq(sender.id)
      expect(user.transferences.last.receiver_id).to eq(receiver.id)
    end
  end
end
