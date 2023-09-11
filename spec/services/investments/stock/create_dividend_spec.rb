require 'rails_helper'

RSpec.describe Investments::Stock::CreateDividend, type: :service do
  context 'with valid attributes' do
    subject(:service) { described_class.call(params) }

    # Parei aqui
    before { create(:negotiation, negotiable: stock, shares: 10) }

    let(:value) { '1.23' }
    let(:stock) { create(:stock) }
    let(:params) do
      {
        date: '2023-01-01',
        value: value,
        stock_id: stock.id
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

    it 'consolidate account report' do
      expect(stock.account.current_report).to eq(nil)

      service
      expect(stock.reload.account.current_report.total_balance_cents)
        .to eq(stock.current_total_value_cents + stock.account.balance_cents)
    end
  end
end
