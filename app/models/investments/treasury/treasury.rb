module Investments
  module Treasury
    class Treasury < ApplicationRecord
      belongs_to :account, class_name: 'Account::Account', touch: true
      has_many :negotiations, as: :negotiable, dependent: :destroy
      has_many :prices, as: :priceable, dependent: :destroy

      validates :name, presence: true
      validates :name,
                uniqueness: { scope: :account_id }

      delegate :user, :name, to: :account, prefix: 'account'

      scope :not_released, -> { where(released: false) }
    end
  end
end
