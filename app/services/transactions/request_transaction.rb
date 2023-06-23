module Transactions
  class RequestTransaction < ApplicationService
    def initialize(params)
      @title = params.fetch(:title)
      @category_id = params.fetch(:category_id, nil)
      @value = params.fetch(:value, 0)
      @kind = params.fetch(:kind)
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
      return -value.to_f if kind == 'expense'
    end

    def update_report_param
      if kind == 'income'
        { income_cents: value.to_f * 100 }
      elsif kind == 'expense'
        { expense_cents: value.to_f * 100 }
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
  end
end

# { title: 'title', category_id: nil, value: '1.23', kind: 'income', account_id: 3,
# date: '2023-06-11', value_to_update_balance: '1.23',
# update_report_param: { income_cents: '1.23'.to_f * 100 }}
