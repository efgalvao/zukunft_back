module Investments
  module Stock
    class Stock < ApplicationRecord
      belongs_to :account, class_name: 'Account::Account', touch: true
      has_many :negotiations, as: :negotiable, dependent: :destroy
      has_many :prices, as: :priceable, dependent: :destroy
      has_many :dividends, class_name: 'Investments::Stock::Dividend', dependent: :destroy

      validates :ticker, presence: true
      validates :ticker,
                uniqueness: { scope: :account_id, message: 'already exists for this account' }

      delegate :user, :name, to: :account, prefix: 'account'
      delegate :id, to: :'account.user', prefix: 'user'
    end
  end
end
