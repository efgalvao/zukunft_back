module Investments
  class NegotiationsController < ApplicationController
    before_action :authenticate_user!

    def create
      @negotiation = Investments::CreateNegotiation.call(negotiation_params)

      serialized_negotiation = Investments::NegotiationSerializer
                               .new(@negotiation)
                               .serializable_hash[:data]

      render json: serialized_negotiation, status: :created
    end

    private

    def negotiation_params
      params.require(:negotiation)
            .permit(:parent_kind, :parent_id, :date, :value, :kind, :shares)
    end
  end
end
