# frozen_string_literals: true

module Account
  class UpdateAccountBalance < ApplicationService
    def initialize(params)
      @account_id = params.fetch(:account_id)
      @value = params.fetch(:value, 0)
    end

    def self.call(params)
      new(params).call
    end

    def call
      update_account_balance
    end

    private

    attr_reader :account_id, :value

    def account
      @account ||= Account.find(account_id)
    end

    def update_account_balance
      account.balance_cents += (value.to_f * 100).to_i
      account.save
    end
  end
end
