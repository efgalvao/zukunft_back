module Account
  class Account < ApplicationRecord
    belongs_to :user

    has_many :reports, class_name: 'Account::AccountReport', dependent: :destroy
    has_many :transactions, class_name: 'Account::Transaction', dependent: :destroy

    enum kind: { savings: 0, broker: 1, card: 2 }

    scope :card_accounts, -> { where(kind: 'card') }
    scope :except_card_accounts, -> { where.not(kind: 'card') }
    scope :broker_accounts, -> { where(kind: 'broker') }

    validates :name, presence: true, uniqueness: true
    validates :kind, presence: true
  end
end
