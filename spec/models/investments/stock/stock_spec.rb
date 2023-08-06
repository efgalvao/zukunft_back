require 'rails_helper'

RSpec.describe Investments::Stock::Stock, type: :model do
  subject { create(:stock) }

  describe 'associations' do
    it { is_expected.to belong_to(:account) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:ticker) }
    it { is_expected.to validate_uniqueness_of(:ticker).scoped_to(:account_id) }
  end
end
