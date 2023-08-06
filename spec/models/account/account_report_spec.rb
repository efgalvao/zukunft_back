require 'rails_helper'

RSpec.describe Account::AccountReport, type: :model do
  subject { create(:account_report) }

  describe 'associations' do
    it { is_expected.to belong_to(:account) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:account_id) }
  end
end
