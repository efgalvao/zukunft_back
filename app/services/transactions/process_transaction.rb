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
      case params.fetch(:kind)
      when 'income'
        Account::UpdateAccountBalance.call(account_id: account_id, amount: value.to_f)
      when 'expense', 'investment'
        Account::UpdateAccountBalance.call(account_id: account_id, amount: -value.to_f)
      when 'transfer'
        if params[:receiver]
          Account::UpdateAccountBalance.call(account_id: account_id, amount: value.to_f)
        else
          Account::UpdateAccountBalance.call(account_id: account_id, amount: -value.to_f)
        end
      else
        return 'Invalid kind'
      end

      Transactions::CreateTransaction.call(params)
    end

    private

    attr_reader :params, :account_id, :value, :date
  end
end
