module Investments
  module Stock
    class DividendSerializer
      include JSONAPI::Serializer
      attributes :stock_id, :date, :value_cents
    end
  end
end
