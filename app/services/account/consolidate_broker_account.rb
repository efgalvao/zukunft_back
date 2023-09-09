# frozen_string_literals: true

module Account
  class ConsolidateBrokerAccount < ApplicationService
    def initialize(account_id:)
      @account_id = account_id
    end

    def self.call(account_id:)
      new(account_id: account_id).call
    end

    def call
      consolidate_account
    end

    private

    attr_reader :account_id

    def account
      @account ||= Account.find(account_id)
    end

    def consolidate_account
      account.balance_cents = account.stocks.sum(:current_total_value_cents)
      account.save
    end
  end
end
