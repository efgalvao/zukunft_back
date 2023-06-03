module Investments
  module Stock
    class StocksController < ApplicationController
      before_action :authenticate_user!
      before_action :set_stock, only: %i[show update destroy]

      def index
        @stocks = Investments::Stock::Stock
                  .joins(:account)
                  .where(account: { user_id: current_user.id })
                  .order(ticker: :asc)

        render json: @stocks, status: :ok
      end

      def create
        @stock = Investments::Stock::CreateStock.call(stock_params)

        render json: @stock, status: :created
      end

      def show
        render json: @stock, status: :ok
      end

      def update
        @stock.update(stock_params)

        render json: @stock, status: :ok
      end

      def destroy
        @stock.destroy
        render json: { 'status': ' ok' }, status: :ok
      end

      private

      def set_stock
        @stock = Stock.find(params[:id])
      end

      def stock_params
        params.require(:stock).permit(:ticker, :account_id)
      end
    end
  end
end
