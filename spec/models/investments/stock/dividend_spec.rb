RSpec.describe Investments::Stock::Dividend, type: :model do
  subject { create(:dividend) }

  it { is_expected.to belong_to(:stock).touch(true) }
end
