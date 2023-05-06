module Transactions
  class ProcessTransaction < ApplicationService
    def initialize(params)
      @params = params
      @account_id = params.fetch(:account_id)
      @value = params.fetch(:value, 0)
      @date = params.fetch(:date)
    end

    def self.call(params)
      new(params).call
    end

    def call
      ActiveRecord::Base.transaction do
        AccountReport::UpdateAccountReport.call(account_id: account_id,
                                                params: update_report_params)
        Account::UpdateAccountBalance.call(account_id: account_id,
                                           value: value_to_update_balance.to_f)
        Transactions::CreateTransaction.call(params)
      end
    end

    private

    attr_reader :params, :account_id, :value, :date

    def value_to_update_balance
      return value if params.fetch(:kind) == 'income'
      return -value.to_f if params.fetch(:kind) == 'expense'

      params.fetch(:value_to_update_balance)
    end

    def update_report_params
      {
        date: date,
        "#{params.fetch(:kind)}_cents": value.to_f * 100
      }
    end
  end
end
