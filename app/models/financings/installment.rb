module Financings
  class Installment < ApplicationRecord
    belongs_to :financing, class_name: 'Financings::Financing'

    validates :financing_id, presence: true
  end
end
