module Investments
  class PricesController < ApplicationController
    before_action :authenticate_user!

    def create
      @price = Investments::CreatePrice.call(prices_params)

      if @price.errors.any?
        render json: { errors: @price.errors }, status: :bad_request
      else
        render json: @price, status: :created
      end
    end

    private

    def prices_params
      params.require(:prices).permit(:parent_kind, :parent_id, :date, :value_cents)
    end
  end
end
