module Account
  class AccountReportSerializer
    include JSONAPI::Serializer
    attributes :incomes_cents, :expenses_cents, :invested_cents, :final_balance_cents, :total_balance_cents, :dividends_cents, :date
  end
end
