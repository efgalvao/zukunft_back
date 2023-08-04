require 'rails_helper'

RSpec.describe Account::Account do
  subject { create(:account) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:reports).class_name('Account::AccountReport').dependent(:destroy) }
    it { is_expected.to have_many(:transactions).class_name('Account::Transaction').dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:kind) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:kind).with_values(savings: 0, broker: 1, card: 2) }
  end
end
