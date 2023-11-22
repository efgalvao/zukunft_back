module Investments
  module Treasury
    class TreasurySerializer
      include JSONAPI::Serializer
      attributes :id, :name, :account_id, :invested_value_cents, :current_value_cents,
                 :released, :negotiations, :prices, :account_name

      has_many :negotiations, serializer: Investments::NegotiationSerializer
      has_many :prices, serializer: Investments::PriceSerializer
    end
  end
end
