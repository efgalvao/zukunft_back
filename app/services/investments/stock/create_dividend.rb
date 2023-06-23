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
        ApplicationRecord.transaction do
          create_transaction
          create_dividend
        end
        if dividend.valid?
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

      def create_dividend
        stock.dividends.create!(dividend_params)
      end

      def create_transaction
        Transactions::ProcessTransaction.call(transaction_params)
      end

      def dividend_params
        {
          date: params[:date],
          value_cents: (params[:value_cents].to_f * 100).to_i
        }
      end

      def transaction_params
        {
          title: "Dividendos #{stock.name}",
          value: params[:value_cents],
          kind: 'income',
          account_id: stock.account_id,
          date: params[:date],
          value_to_update_balance: params[:value_cents],
          update_report_param: { income_cents: value.to_f * 100 }
        }
      end
    end
  end
end
