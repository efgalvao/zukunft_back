# frozen_string_literal: true

RSpec.describe Account::Transaction, type: :model do
  subject { create(:transaction) }

  describe 'associations' do
    it { is_expected.to belong_to(:account) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:kind) }
    it { is_expected.to validate_presence_of(:account_id) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:kind).with_values(expense: 0, income: 1, transfer: 2, investment: 3) }
  end
end
