module Investments
  class Negotiation < ApplicationRecord
    belongs_to :negotiable, polymorphic: true
  end
end
