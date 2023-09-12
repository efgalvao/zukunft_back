module Transferences
  class ProcessTransference < ApplicationService
    def initialize(params)
      @receiver_id = params.fetch(:receiver_id)
      @sender_id = params.fetch(:sender_id)
      @user_id = params.fetch(:user_id)
      @date = params.fetch(:date)
      @value = params.fetch(:value)
    end

    def self.call(params)
      new(params).call
    end

    def call
      request_receiver_transaction
      request_sender_transaction
    end

    private

    attr_reader :receiver_id, :sender_id, :user_id, :date, :value

    def request_receiver_transaction
      Transactions::RequestTransaction.call(receiver_params)
    end

    def request_sender_transaction
      Transactions::RequestTransaction.call(sender_params)
    end

    def fetch_date(date) = date.present? ? date.to_date : Time.zone.today

    def receiver_params
      {
        account_id: receiver.id,
        value: value,
        kind: 'transfer',
        title: "Transference from #{sender.name}",
        date: date
      }
    end

    def sender_params
      {
        account_id: sender.id,
        value: value.to_f,
        kind: 'transfer',
        title: "Transference to #{receiver.name}",
        date: date
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
