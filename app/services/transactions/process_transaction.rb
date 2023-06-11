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
        Account::UpdateAccountBalance.call(account_id: account_id,
                                           value: value_to_update_balance)
        if params.fetch(:kind) != 'transfer'
          AccountReport::UpdateAccountReport.call(account_id: account_id,
                                                  params: update_report_params)
        end
        Transactions::CreateTransaction.call(params)
      end
    end

    private

    attr_reader :params, :account_id, :value, :date

    def value_to_update_balance
      params.fetch(:value_to_update_balance).to_f
    end

    def update_report_params
      { date: date }.merge(params.fetch(:update_report_param))
    end
  end
end
