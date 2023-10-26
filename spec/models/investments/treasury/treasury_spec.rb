require 'rails_helper'

RSpec.describe Investments::Treasury::Treasury, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:account).class_name('Account::Account').touch(true) }
    it { is_expected.to have_many(:negotiations).dependent(:destroy) }
    it { is_expected.to have_many(:prices).dependent(:destroy) }
  end

  describe 'validations' do
    subject { FactoryBot.build(:treasury) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:account_id) }
  end
end
