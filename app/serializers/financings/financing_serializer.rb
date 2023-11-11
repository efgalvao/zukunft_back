module Financings
  class FinancingSerializer
    include JSONAPI::Serializer

    attributes :id, :borrowed_value_cents, :installments, :name
  end
end
