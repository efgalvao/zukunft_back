module Investments
  module Stock
    class StocksController < ApplicationController
      before_action :authenticate_user!
      before_action :set_stock, only: %i[show update destroy]

      def index
        stocks = Investments::Stock::Stock
                 .joins(:account)
                 .where(account: { user_id: current_user.id }, account_id: params[:account_id])
                 .order(ticker: :asc)

        serialized_stocks = Investments::Stock::StockSerializer.new(stocks).serializable_hash[:data]

        render json: serialized_stocks, status: :ok
      end

      def create
        stock = Investments::Stock::CreateStock.call(stock_params)
        serialized_stock = Investments::Stock::StockSerializer
                           .new(stock)
                           .serializable_hash[:data][:attributes]

        render json: serialized_stock, status: :created
      end

      def show
        serialized_stock = Investments::Stock::StockSerializer
                           .new(@stock)
                           .serializable_hash[:data][:attributes]

        render json: serialized_stock, status: :ok
      end

      def update
        @stock.update(stock_params)
        serialized_stock = Investments::Stock::StockSerializer
                           .new(@stock)
                           .serializable_hash[:data][:attributes]

        render json: serialized_stock, status: :ok
      end

      def destroy
        @stock.destroy
        render json: { 'status': ' ok' }, status: :ok
      end

      private

      def set_stock
        @stock = Investments::Stock::Stock
                 .includes(:dividends, :prices, :negotiations)
                 .order('dividends.date ASC')
                 .order('negotiations.date ASC')
                 .order('prices.date ASC')
                 .find(params[:id])
      end

      def stock_params
        params.require(:stock).permit(:ticker, :account_id)
      end
    end
  end
end
