# frozen_string_literals: true

module Account
  class CreateAccount < ApplicationService
    def initialize(params)
      @balance_cents = params.fetch(:balance_cents, 0)
      @name = params.fetch(:name, nil)
      @kind = params.fetch(:kind, 0)
      @user_id = params.fetch(:user_id, nil)
    end

    def self.call(params)
      new(params).call
    end

    def call
      create_account
    end

    private

    attr_reader :balance_cents, :name, :kind, :user_id

    def create_account
      ActiveRecord::Base.transaction do
        Account.create(name: name, balance_cents: balance_cents, kind: kind, user_id: user_id)
      end
    end
  end
end
