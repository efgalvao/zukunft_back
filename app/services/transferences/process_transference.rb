module Transferences
  class ProcessTransference < ApplicationService
    def initialize(params)
      @receiver_id = params.fetch(:receiver_id)
      @sender_id = params.fetch(:sender_id)
      @user_id = params.fetch(:user_id)
      @date = fetch_date(params.fetch(:date))
      @value = params.fetch(:value)
    end

    def self.call(params)
      new(params).call
    end

    def call
      process_receiver_transaction
      process_sender_transaction
    end

    private

    attr_reader :receiver_id, :sender_id, :user_id, :date, :value

    def process_receiver_transaction
      Transactions::ProcessTransaction.call(receiver_params)
    end

    def process_sender_transaction
      Transactions::ProcessTransaction.call(sender_params)
    end

    def fetch_date(date) = date.present? ? date.to_date : Time.zone.today

    def receiver_params
      {
        account_id: receiver.id, value: value, kind: 'transfer', receiver: true,
        title: "Transference from #{sender.name}", date: date, value_to_update_balance: value
      }
    end

    def sender_params
      {
        account_id: sender.id, value: value, kind: 'transfer', receiver: true,
        title: "Transference to #{receiver.name}", date: date, value_to_update_balance: -value
      }
    end

    def receiver
      @receiver ||= Account::Account.find(receiver_id)
    end

    def sender
      @sender ||= Account::Account.find(sender_id)
    end
  end
end
