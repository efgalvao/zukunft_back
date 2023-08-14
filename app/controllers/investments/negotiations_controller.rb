module Investments
  class NegotiationsController < ApplicationController
    before_action :authenticate_user!

    def create
      @negotiation = Investments::CreateNegotiation.call(negotiation_params)

      if @negotiation.errors.any?
        render json: { errors: @negotiation.errors }, status: :bad_request
      else
        render json: @negotiation, status: :created
      end
    end

    private

    def negotiation_params
      params.require(:negotiations).permit(:parent_kind, :parent_id, :date, :value_cents)
    end
  end
end
