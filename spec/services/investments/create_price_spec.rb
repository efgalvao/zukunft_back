require 'rails_helper'

RSpec.describe Investments::CreatePrice, type: :service do
  context 'with valid attributes' do
    subject(:service) { described_class.call(params) }

    before { create(:negotiation, negotiable: stock, shares: 10) }

    let(:value_cents) { '1.23' }
    let(:stock) { create(:stock, shares_total: 0) }
    let(:params) do
      {
        date: '2023-01-01',
        value_cents: value_cents,
        parent_kind: 'stock',
        parent_id: stock.id
      }
    end

    it 'create price', :aggregate_failures do
      expect { service }.to change(Investments::Price, :count).by(1)
      expect(stock.reload.prices.count).to eq(1)
      expect(stock.prices.last.value_cents).to eq((value_cents.to_f * 100).to_i)
    end

    it 'consolidate stock' do
      service

      expect(stock.reload.current_value_cents).to eq((value_cents.to_f * 100).to_i)
      expect(stock.current_total_value_cents).to eq((value_cents.to_f * 100).to_i * stock.shares_total)
    end

    it 'consolidate account' do
      expect(stock.account.balance_cents).to eq(100)

      service

      expect(stock.reload.account.balance_cents).to eq(stock.current_total_value_cents)
    end
  end
end
