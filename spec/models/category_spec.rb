RSpec.describe Category, type: :model do
  subject { create(:category) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
