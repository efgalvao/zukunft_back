module Investments
  class PricesController < ApplicationController
    before_action :authenticate_user!

    def create
      Investments::CreatePrice.call(prices_params)

      render json: { status: 'created' }, status: :created
    rescue StandardError
      render json: { status: 'error' }, status: :unprocessable_entity
    end

    private

    def prices_params
      params.require(:price).permit(:parent_kind, :parent_id, :date, :value)
    end
  end
end
