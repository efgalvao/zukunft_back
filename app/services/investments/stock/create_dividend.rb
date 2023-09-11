module Investments
  module Stock
    class CreateDividend < ApplicationService
      def initialize(params)
        @value = params[:value]
        @stock_id = params[:stock_id]
        @date = params[:date]
      end

      def self.call(params)
        new(params).call
      end

      def call
        ApplicationRecord.transaction do
          dividend = create_dividend
          create_transaction if dividend.valid?
          dividend
        end
      end

      private

      attr_reader :value, :stock_id, :date

      def stock
        @stock ||= Investments::Stock::Stock.find_by(id: stock_id)
      end

      def create_dividend
        Investments::Stock::Dividend.create(dividend_params)
      end

      def create_transaction
        Transactions::ProcessTransaction.call(transaction_params)
      end

      def dividend_params
        {
          date: date,
          value_cents: (value.to_f * 100).to_i,
          stock_id: stock_id
        }
      end

      def transaction_params
        {
          title: "Dividendos #{stock.ticker}",
          value: value,
          kind: 'income',
          account_id: stock.account_id,
          date: date
        }
      end
    end
  end
end
