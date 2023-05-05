class Transference < ApplicationRecord
  belongs_to :sender, class_name: 'Account::Account'
  belongs_to :receiver, class_name: 'Account::Account'
  belongs_to :user

  validates :value_cents, presence: true
  validate :different_accounts

  delegate :name, to: :sender, prefix: 'sender'
  delegate :name, to: :receiver, prefix: 'receiver'

  def different_accounts
    errors.add :base, 'Accounts must be different' if sender_id == receiver_id
  end
end
