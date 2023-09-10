module Investments
  class PriceSerializer
    include JSONAPI::Serializer
    attributes :date, :value_cents, :priceable_type, :priceable_id
  end
end
