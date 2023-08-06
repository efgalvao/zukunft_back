FactoryBot.define do
  factory :account_report, class: Account::AccountReport do
    account { create(:account) }
    incomes_cents { 1000 }
    expenses_cents { 1000 }
    invested_cents { 1000 }
    final_balance_cents { 1000 }
    total_balance_cents { 1000 }
    dividends_cents { 1000 }
    date { Time.zone.today }
  end
end
