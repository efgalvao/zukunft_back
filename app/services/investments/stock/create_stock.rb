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
        stock = Investments::Stock::Stock.new(@params)

        if stock.save
          stock
        else
          stock.errors
        end
      end
    end
  end
end
