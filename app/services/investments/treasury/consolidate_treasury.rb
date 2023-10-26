# frozen_string_literals: true

module Investments
  module Treasury
    class ConsolidateTreasury < ApplicationService
      def initialize(treasury_id:)
        @treasury_id = treasury_id
      end

      def self.call(treasury_id:)
        new(treasury_id: treasury_id).call
      end

      def call
        consolidate_treasury
      end

      private

      attr_reader :treasury_id

      def treasury
        @treasury ||= Investments::Treasury::Treasury.find(treasury_id)
      end

      def consolidate_treasury
        treasury.current_value_cents = current_price
        treasury.invested_value_cents = consolidated_invested_value_cents
        treasury.save!
      end

      def consolidated_invested_value_cents
        treasury.negotiations.sum(:invested_cents)
      end

      def current_price
        treasury.prices.order(date: :desc).first.value_cents
      end
    end
  end
end
