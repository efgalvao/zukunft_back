module Transference
  class RetrieveTransference < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      @user.transferences
    end

    private

    attr_reader :user_id

    def transferences
      date_range = Date.today.beginning_of_month..Date.today.end_of_month
      Transference.where(user_id: user_id, date: date_range)
    end
  end
end
