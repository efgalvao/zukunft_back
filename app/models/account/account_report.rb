module Account
  class AccountReport < ApplicationRecord
    belongs_to :account

    validates :account_id, presence: true
  end
end
