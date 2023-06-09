module Investments
  module Stock
    class Dividend < ApplicationRecord
      belongs_to :stock, touch: true
    end
  end
end
