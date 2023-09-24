# frozen_string_literals: true

module Account
  class CreateAccount < ApplicationService
    def initialize(params)
      @balance = params.fetch(:balance, 0)
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

    attr_reader :balance, :name, :kind, :user_id

    def create_account
      ActiveRecord::Base.transaction do
        Account.create(name: name, balance_cents: balance_cents, kind: kind, user_id: user_id)
      end
    end

    def balance_cents
      balance.to_f * 100
    end
  end
end
