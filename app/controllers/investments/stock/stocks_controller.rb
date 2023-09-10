module Investments
  module Stock
    class StocksController < ApplicationController
      before_action :authenticate_user!
      before_action :set_stock, only: %i[show update destroy]

      def index
        @stocks = Investments::Stock::Stock
                  .joins(:account)
                  .where(account: { user_id: current_user.id }, account_id: params[:stock][:account_id])
                  .order(ticker: :asc)

        serialized_stocks = Investments::Stock::StockSerializer
                            .new(@stocks, { include: %i[negotiations prices dividends] })
                            .serializable_hash

        render json: serialized_stocks, status: :ok
      end

      def create
        stock = Investments::Stock::CreateStock.call(stock_params)
        if stock.valid?
          serialized_stock = Investments::Stock::StockSerializer
                             .new(stock, { include: %i[negotiations prices dividends] })
                             .serializable_hash

          render json: serialized_stock, status: :created
        else
          render json: { errors: stock.errors.full_messages.to_sentence },
                 status: :unprocessable_entity
        end
      end

      def show
        serialized_stock = Investments::Stock::StockSerializer
                           .new(@stock, { include: %i[negotiations prices dividends] })
                           .serializable_hash

        render json: serialized_stock, status: :ok
      end

      def update
        @stock.update(stock_params)

        if @stock.valid?
          serialized_stock = Investments::Stock::StockSerializer
                             .new(@stock, { include: %i[negotiations prices dividends] })
                             .serializable_hash

          render json: serialized_stock, status: :ok
        else
          render json: { errors: @stock.errors.full_messages.to_sentence },
                 status: :unprocessable_entity
        end
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
        params.require(:stock).permit(:ticker, :account_id, :invested_value_cents,
                                      :current_value_cents, :current_total_value_cents,
                                      :shares_total)
      end
    end
  end
end
