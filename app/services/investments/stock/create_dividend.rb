module Investments
  module Stock
    class CreateDividend < ApplicationService
      def initialize(params)
        @params = params
      end

      def self.call(params)
        new(params).call
      end

      def call
        dividend = stock.dividends.new(dividend_params)

        if dividend.save
          dividend
        else
          dividend.errors
        end
      end

      private

      attr_reader :params

      def stock
        @stock ||= Investments::Stock::Stock.find(params[:stock_id])
      end

      def dividend_params
        {
          date: params[:date],
          value_cents: (params[:value_cents].to_f * 100).to_i
        }
      end
    end
  end
end
