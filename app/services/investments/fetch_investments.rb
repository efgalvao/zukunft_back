module Investments
  class FetchInvestments
    def initialize(user_id)
      @user_id = user_id
    end

    def self.call(user_id)
      new(user_id).call
    end

    def call
      fetch_investments
    end

    private

    attr_reader :user_id

    def fetch_investments
      accounts = Account::Account.where(user_id: user_id)
      investments = []

      accounts.each do |account|
        investments.concat(account.stocks)
        investments.concat(account.treasuries)
      end

      investments
    end
  end
end
