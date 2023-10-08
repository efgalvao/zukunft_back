module Transactions
  class BuildStatement
    def initialize(account_id:, user_id:)
      @account_id = account_id
      @user_id = user_id
    end

    def self.build(account_id:, user_id:)
      new(account_id: account_id, user_id: user_id).build
    end

    def build
      build_payload
    rescue StandardError
      { future_transactions: [], past_transactions: [] }
    end

    private

    attr_reader :account_id, :user_id

    def account
      @account ||= ::Account::Account.find_by(id: account_id, user_id: user_id)
    end

    def serialized_transactions(transactions)
      ::Account::TransactionSerializer.new(transactions).serializable_hash[:data]
    end

    def build_payload
      {
        future_transactions: serialized_transactions(future_transactions).map { |t| t[:attributes] },
        past_transactions: serialized_transactions(past_transactions).map { |t| t[:attributes] }
      }
    end

    def future_transactions
      ::Account::Transaction.where(account_id: account.id).where('date > ?', Time.zone.today).order(date: :asc)
    end

    def past_transactions
      ::Account::Transaction.where(account_id: account.id).where('date <= ?', Time.zone.today).order(date: :desc)
    end
  end
end
