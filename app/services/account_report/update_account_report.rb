# frozen_string_literals: true

module AccountReport
  class UpdateAccountReport < ApplicationService
    def initialize(account_id:, params:)
      @account_id = account_id
      @params = params
    end

    def self.call(account_id:, params:)
      new(account_id: account_id, params: params).call
    end

    def call
      update_account_report
    end

    private

    attr_reader :account_id, :params

    def update_account_report = report.update(new_attributes)

    def report
      @report ||= begin
        current_report = account.reports.find_by(
          date: date.beginning_of_month..date.end_of_month
        )
        current_report.presence || AccountReport::CreateAccountReport.call(
          account_id: account_id, date: date
        )
      end
    end

    def account
      @account ||= Account::Account.find(account_id)
    end

    def date
      # refatorar
      @date ||= if params.fetch(:date).present?
                  Date.parse(params.fetch(:date)) if params.fetch(:date).instance_of?(String)
                else
                  Date.current
                end
    end

    def new_attributes
      {
        date: date,
        incomes_cents: incomes,
        expenses_cents: expenses,
        invested_cents: invested,
        dividends_cents: dividends,
        final_balance_cents: final_balance_cents,
        total_balance_cents: total_balance
      }
    end

    def incomes
      params.fetch(:income_cents, 0) + report.incomes_cents
    end

    def expenses
      params.fetch(:expense_cents, 0) + report.expenses_cents
    end

    def invested
      params.fetch(:investment_cents, 0) + report.invested_cents
    end

    def dividends
      params.fetch(:dividends_cents, 0) + report.dividends_cents
    end

    def final_balance_cents
      incomes - expenses - invested
    end

    def total_balance
      # TODO
      # account.treasuries.where(released_at: nil).order(name: :asc).sum(&:current_value_cents) +
      #   account.stocks.sum(&:current_total_value_cents) +
      account.balance_cents
    end
  end
end
