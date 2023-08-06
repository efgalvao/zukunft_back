RSpec.describe User, type: :model do
  subject { create(:user) }

  describe 'associations' do
    it { is_expected.to have_many(:accounts).class_name('Account::Account').dependent(:destroy) }
    it { is_expected.to have_many(:transferences).class_name('Transference').dependent(:destroy) }
    it { is_expected.to have_many(:categories).class_name('Category').dependent(:destroy) }
  end
end
