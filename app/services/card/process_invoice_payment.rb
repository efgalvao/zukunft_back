module Card
  class ProcessInvoicePayment < ApplicationService
    def initialize(params)
      @account_id = params.fetch(:account_id)
      @card_id = params.fetch(:card_id)
      @value = params.fetch(:value, 0).to_f
      @date = params.fetch(:date, '')
      @description = params.fetch(:description, '')
    end

    def self.call(params)
      new(params).call
    end

    def call
      ActiveRecord::Base.transaction do
        Transactions::RequestTransaction.call(account_params)
        Transactions::RequestTransaction.call(card_params)
      end
    rescue StandardError
      false
    end

    private

    attr_reader :account_id, :card_id, :value, :date, :description

    def account_params
      { account_id: account_id, value: value, kind: 'expense', title: description, date: date }
    end

    def card_params
      { account_id: card_id, value: value, kind: 'income', title: description, date: date }
    end
  end
end
