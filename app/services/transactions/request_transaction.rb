module Transactions
  class RequestTransaction < ApplicationService
    def initialize(params)
      @title = params.fetch(:title, nil)
      @category_id = params.fetch(:category_id, nil)
      @value = params.fetch(:value, 0)
      @kind = params.fetch(:kind, nil)
      @account_id = params.fetch(:account_id)
      @date = params.fetch(:date)
    end

    def self.call(params)
      new(params).call
    end

    def call
      Transactions::ProcessTransaction.call(transaction_params)
    end

    private

    attr_reader :title, :category_id, :value, :kind, :account_id, :date

    def value_to_update_balance
      return value if kind == 'income'
      return -value if kind == 'expense'
    end

    def update_report_param
      case kind
      when 'income'
        { income_cents: value_in_cents }
      when 'expense'
        { expense_cents: value_in_cents }
      when 'investment'
        { invested_cents: value_in_cents }
      end
    end

    def transaction_params
      {
        title: title,
        category_id: category_id,
        value: value,
        kind: kind,
        account_id: account_id,
        date: date,
        value_to_update_balance: value_to_update_balance,
        update_report_param: update_report_param
      }
    end

    def value_in_cents
      (value.to_f * 100).to_i
    end
  end
end
