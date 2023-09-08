module Investments
  module Stock
    class DividendsController < ApplicationController
      before_action :authenticate_user!

      def create
        @stock = Investments::Stock::CreateDividend.call(dividends_params)

        if @stock.valid?
          serialized_dividend = DividendSerializer.new(@stock).serializable_hash[:data]
          render json: serialized_dividend, status: :created
        else
          render json: { errors: @stock.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
      end

      private

      def dividends_params
        params.require(:dividend).permit(:stock_id, :date, :value)
      end
    end
  end
end
