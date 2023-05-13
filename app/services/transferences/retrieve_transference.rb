module Transferences
  class RetrieveTransference < ApplicationService
    def initialize(user_id)
      @user_id = user_id
    end

    def self.call(user_id)
      new(user_id).call
    end

    def call
      format_response(transferences)
    end

    private

    attr_reader :user_id

    def format_response(transferences)
      transferences.map do |transference|
        {
          sender: transference.sender.name,
          receiver: transference.receiver.name,
          value_cents: transference.value_cents,
          date: transference.date
        }
      end
    end

    def transferences
      date_range = Time.zone.today.beginning_of_month..Time.zone.today.end_of_month
      Transference.where(user_id: user_id).where(date: date_range)
    end
  end
end
