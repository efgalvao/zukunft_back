require 'rails_helper'

RSpec.describe Investments::Treasury::ConsolidateTreasury do
  subject(:service_call) { described_class.new(treasury_id: treasury.id).call }

  describe '.call' do
    let(:treasury) { create(:treasury, invested_value_cents: 0, current_value_cents: 0) }
    let!(:price) { create(:price, value_cents: 100, priceable_type: treasury.class, priceable_id: treasury.id) }
    let!(:negotiation) { create(:negotiation, invested_cents: 100, negotiable_type: treasury.class, negotiable_id: treasury.id) }

    it 'consolidates treasury data' do
      service_call

      expect(treasury.reload.invested_value_cents).to eq(negotiation.invested_cents)
      expect(treasury.reload.current_value_cents).to eq(price.value_cents)
    end
  end
end
