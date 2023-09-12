require 'rails_helper'

RSpec.describe Investments::Stock::CreateDividend, type: :service do
  context 'with valid attributes' do
    subject(:service) { described_class.call(params) }

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

    it 'create dividend', :aggregate_failures do
      expect { service }.to change(Investments::Stock::Dividend, :count).by(1)
      expect(stock.reload.dividends.count).to eq(1)
      expect(stock.dividends.last.value_cents).to eq((value.to_f * 100).to_i)
    end

    it 'create transaction' do
      expect(stock.account.transactions.first).to eq(nil)

      service
      expect(stock.reload.account.transactions.first.value_cents)
        .to eq((value.to_f * 100).to_i)
    end
  end
end
