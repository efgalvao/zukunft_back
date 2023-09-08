module Investments
  module Stock
    class UpdateStock < ApplicationService
      def initialize(params)
        @stock_id = params.fetch(:stock_id)
        @date = params.fetch(:date, Time.current)
        @quantity = params.fetch(:quantity, 0)
        @invested = params.fetch(:invested, 0)
      end

      def self.call(params)
        new(params).call
      end

      def call
        update_stock
      end

      private

      attr_reader :stock_id, :date, :quantity, :invested

      def value
        @value ||= invested.to_f / quantity
      end

      def invested_cents
        @invested_cents ||= invested + 100
      end

      def update_stock
        ActiveRecord::Base.transaction do
          stock.shares_total += quantity.to_i
          stock.invested_value_cents += invested_cents
          stock.current_value_cents = new_current_value_cents
          stock.current_total_value_cents = new_current_total_value_cents

          stock.save!
        end
      end

      def new_current_value_cents
        if value.zero?
          stock.current_value_cents
        else
          value * 100
        end
      end

      def new_current_total_value_cents
        if value.zero?
          stock.current_total_value_cents
        else
          (value * 100) * stock.shares_total
        end
      end

      def stock
        @stock ||= Investments::Stock::Stock.find(stock_id)
      end
    end
  end
end
