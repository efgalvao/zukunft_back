module Investments
  module Stock
    class StockSerializer
      include JSONAPI::Serializer
      attributes :ticker, :account_id, :invested_value_cents, :current_value_cents,
                 :current_total_value_cents, :shares_total

      has_many :dividends, serializer: Investments::Stock::DividendSerializer
      has_many :negotiations, serializer: Investments::NegotiationSerializer
      has_many :prices, serializer: Investments::PriceSerializer
    end
  end
end
