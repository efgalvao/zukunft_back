module Investments
  class NegotiationsController < ApplicationController
    before_action :authenticate_user!

    def create
      @negotiation = Investments::CreateNegotiation.call(negotiation_params)

      if @negotiation.valid?
        serialized_negotiation = Investments::NegotiationSerializer
                                 .new(@negotiation)
                                 .serializable_hash[:data]

        render json: serialized_negotiation, status: :created
      else
        render json: { errors: @negotiation.errors.full_messages.to_sentence },
               status: :unprocessable_entity
      end
    end

    private

    def negotiation_params
      params.require(:negotiations).permit(:parent_kind, :parent_id, :date, :value_cents)
    end
  end
end
