module Users
  class BuildSummary
    def initialize(user_id)
      @user_id = user_id
    end

    def self.fetch(user_id)
      new(user_id).fetch
    end

    def fetch
      build_summary
    end

    private

    attr_reader :user_id

    def user
      @user ||= User.includes(:accounts).find(user_id)
    end

    def build_summary
      {
        id: user.id,
        name: user.name,
        user_summary: build_user_summary,
        month_summary: build_month_summary,
        accounts: user.accounts.map do |account|
          build_account_summary(account)
        end
      }
    end

    def build_user_summary
      {
        sum_balance_cents: user.accounts.sum(:balance_cents),
        sum_balance_plus_invested_cents: sum_balance_plus_invested_cents,
        sum_current_invested_cents: sum_current_invested_cents,
        sum_invested_cents: sum_invested_cents
      }
    end

    def sum_balance_plus_invested_cents
      user.accounts.map do |account|
        account.treasuries.where(released: false).sum(:current_value_cents) +
          account.stocks.sum(:current_total_value_cents) +
          account.balance_cents
      end.sum
    end

    def sum_current_invested_cents
      user.accounts.map do |account|
        account.stocks.sum(:current_total_value_cents) +
          account.treasuries.sum(:current_value_cents)
      end.sum
    end

    def sum_invested_cents
      user.accounts.map do |account|
        account.stocks.sum(:invested_value_cents) +
          account.treasuries.sum(:invested_value_cents)
      end.sum
    end

    def build_month_summary
      {
        income_cents: incomes_cents,
        expenses_cents: expenses_cents,
        invested_cents: invested_cents,
        final_balance_cents: final_balance_cents
      }
    end

    def incomes_cents
      user.accounts.map do |account|
        account.current_report.incomes_cents
      end.sum
    end

    def expenses_cents
      user.accounts.map do |account|
        account.current_report.expenses_cents
      end.sum
    end

    def invested_cents
      user.accounts.map do |account|
        account.current_report.invested_cents
      end.sum
    end

    def final_balance_cents
      user.accounts.map do |account|
        account.current_report.final_balance_cents
      end.sum
    end

    def build_account_summary(account)
      {
        id: account.id,
        name: account.name,
        kind: account.kind,
        balance_cents: account.balance_cents,
        balance_plus_invested_cents: balance_plus_invested_cents(account),
        current_invested_cents: current_invested_cents(account),
        updated_at: account.updated_at
      }
    end

    def balance_plus_invested_cents(account)
      account.treasuries.where(released: false).sum(:current_value_cents) +
        account.stocks.sum(:current_total_value_cents) +
        account.balance_cents
    end

    def current_invested_cents(account)
      account.stocks.sum(:current_total_value_cents) +
        account.treasuries.sum(:current_value_cents)
    end
  end
end
