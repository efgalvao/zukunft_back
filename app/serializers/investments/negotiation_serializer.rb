module Investments
  module Stock
    class Investments::NegotiationSerializer
      include JSONAPI::Serializer
      attributes :kind, :date, :invested_cents, :shares, :negotiable_type, :negotiable_id
    end
  end
end
