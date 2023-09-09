# frozen_string_literals: true

module Investments
  module Stock
    class ConsolidateStock < ApplicationService
      def initialize(stock_id:)
        @stock_id = stock_id
      end

      def self.call(stock_id:)
        new(stock_id: stock_id).call
      end

      def call
        consolidate_stock
      end

      private

      attr_reader :stock_id

      def stock
        @stock ||= Investments::Stock::Stock.find(stock_id)
      end

      def consolidate_stock
        stock.current_value_cents = current_price
        stock.current_total_value_cents = current_price * consolidated_shares
        stock.invested_value_cents = consolidated_invested_value_cents
        stock.shares_total = consolidated_shares
        stock.save!
      end

      def consolidated_shares
        stock.negotiations.sum(:shares)
      end

      def consolidated_invested_value_cents
        stock.negotiations.sum(:invested_cents)
      end

      def current_price
        stock.prices.order(date: :desc).first.value_cents
      end
    end
  end
end
