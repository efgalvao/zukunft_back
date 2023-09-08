module Investments
  module Stock
    class CreateDividend < ApplicationService
      def initialize(params)
        @params = params
        @value_cents = params[:value].to_f
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

      attr_reader :params, :value_cents

      def stock
        @stock ||= Investments::Stock::Stock.find_by(id: params[:stock_id])
      end

      def create_dividend
        Investments::Stock::Dividend.create(dividend_params)
      end

      def create_transaction
        Transactions::ProcessTransaction.call(transaction_params)
      end

      def dividend_params
        {
          date: params[:date],
          value_cents: (value_cents * 100).to_i,
          stock_id: params[:stock_id]
        }
      end

      def transaction_params
        {
          title: "Dividendos #{stock.ticker}",
          value: value_cents,
          kind: 'income',
          account_id: stock.account_id,
          date: params[:date],
          value_to_update_balance: value_cents,
          update_report_param: { income_cents: value_cents * 100 }
        }
      end
    end
  end
end
