module Investments
  module Treasury
    class UpdateTreasury < ApplicationService
      def initialize(params)
        @treasury_id = params.fetch(:treasury_id)
        @name = params.fetch(:name, nil)
        @released = params.fetch(:released, false)
      end

      def self.call(params)
        new(params).call
      end

      def call
        update_treasury
      end

      private

      attr_reader :treasury_id, :name, :released

      def released?
        released || treasury.released
      end

      def update_treasury
        ActiveRecord::Base.transaction do
          treasury.name = name
          treasury.released = released?

          treasury.save
          treasury
        end
      end

      def treasury
        @treasury ||= Investments::Treasury::Treasury.find(treasury_id)
      end
    end
  end
end
