module Investments
  module Stock
    class CreateStock < ApplicationService
      def initialize(params)
        @params = params
      end

      def self.call(params)
        new(params).call
      end

      def call
        Investments::Stock::Stock.create(@params)
      end
    end
  end
end
