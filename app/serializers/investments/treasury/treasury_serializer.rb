module Investments
  module Treasury
    class TreasurySerializer
      include JSONAPI::Serializer
      attributes :name, :account_id, :invested_value_cents, :current_value_cents,
                 :released, :negotiations, :prices

      has_many :negotiations, serializer: Investments::NegotiationSerializer
      has_many :prices, serializer: Investments::PriceSerializer
    end
  end
end
