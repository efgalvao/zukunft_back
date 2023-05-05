module Transference
  class CreateTransference < ApplicationService
    def initialize(params)
      @receiver_id = params.fetch('receiver_id')
      @sender_id = params.fetch('sender_id')
      @user_id = params.fetch('user_id')
      @date = set_date
      @value = params.fetch('value')
    end

    def self.call(params)
      new(params).call
    end

    def call
      ActiveRecord::Base.transaction do
        create_transference
        process_transference
      end
    end

    private

    attr_reader :receiver_id, :sender_id, :user_id, :date, :value

    def set_date = params[:date].present? ? params[:date].to_date : Time.zone.today

    def formated_value = value.to_f * 100

    def create_transference
      Transference::Transference.create!(
        receiver_id: receiver_id,
        sender_id: sender_id,
        user_id: user_id,
        date: date,
        value_cents: formated_value
      )
    end

    def process_transference = Transferences::ProcessTransference.call(process_transference_params)

    def process_transference_params
      {
        receiver_id: receiver_id,
        sender_id: sender_id,
        user_id: user_id,
        date: date,
        value: value
      }
    end
  end
end
