class Investments::Stock::StockSerializer
  include JSONAPI::Serializer
  attributes :ticker, :account_id, :invested_value_cents, :current_value_cents,
             :current_total_value_cents, :shares_total, :dividends, :prices, :negotiations
end
