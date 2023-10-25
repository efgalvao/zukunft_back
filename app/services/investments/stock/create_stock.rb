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
        Investments::Stock::Stock.create(stock_attributes)
      end

      private

      attr_reader :params

      def stock_attributes
        {
          ticker: params[:ticker],
          invested_value_cents: convert_to_cents(params[:invested_value_cents]),
          current_value_cents: convert_to_cents(params[:current_value_cents]),
          current_total_value_cents: convert_to_cents(params[:current_total_value_cents]),
          shares_total: params[:shares_total],
          account_id: params[:account_id]
        }
      end

      def convert_to_cents(value)
        (value.to_f * 100).to_i
      end
    end
  end
end
