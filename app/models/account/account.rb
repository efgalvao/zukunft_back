module Account
  class Account < ApplicationRecord
    belongs_to :user

    has_many :reports, class_name: 'Account::AccountReport', dependent: :destroy
    has_many :transactions, class_name: 'Account::Transaction', dependent: :destroy
    has_many :stocks, class_name: 'Investments::Stock::Stock', dependent: :destroy

    enum kind: { savings: 0, broker: 1, card: 2 }

    scope :card_accounts, -> { where(kind: 'card') }
    scope :except_card_accounts, -> { where.not(kind: 'card') }
    scope :broker_accounts, -> { where(kind: 'broker') }

    validates :name, presence: true, uniqueness: true
    validates :kind, presence: true

    def current_report
      reports.find_by(date: Date.current.beginning_of_month..Date.current.end_of_month)
    end
  end
end
