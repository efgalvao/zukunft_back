FactoryBot.define do
  factory :account_report, class: Account::AccountReport do
    account { create(:account) }
    incomes_cents { rand(1.0..1000.0).round(2) }
    expenses_cents { rand(1.0..1000.0).round(2) }
    invested_cents { rand(1.0..1000.0).round(2) }
    final_balance_cents { rand(1.0..1000.0).round(2) }
    total_balance_cents { rand(1.0..1000.0).round(2) }
    dividends_cents { rand(1.0..1000.0).round(2) }
    date { Time.zone.today }
  end
end
