module Investments
  module Treasury
    class CreateTreasury < ApplicationService
      def initialize(params)
        @params = params
      end

      def self.call(params)
        new(params).call
      end

      def call
        Investments::Treasury::Treasury.create(treasury_attributes)
      end

      private

      attr_reader :params

      def treasury_attributes
        {
          name: params[:name],
          invested_value_cents: convert_to_cents(params[:invested_value_cents]),
          current_value_cents: convert_to_cents(params[:current_value_cents]),
          account_id: params[:account_id]
        }
      end

      def convert_to_cents(value)
        (value.to_f * 100).to_i
      end
    end
  end
end
