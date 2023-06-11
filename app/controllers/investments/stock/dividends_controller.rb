module Investments
  module Stock
    class DividendsController < ApplicationController
      before_action :authenticate_user!

      def create
        @stock = Investments::Stock::CreateDividend.call(dividends_params)

        if @stock.errors.any?
          render json: { errors: @stock.errors }, status: :bad_request
        else
          render json: @stock, status: :created
        end
      end

      private

      def dividends_params
        params.require(:dividends).permit(:stock_id, :date, :value_cents)
      end
    end
  end
end
