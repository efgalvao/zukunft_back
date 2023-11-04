module Investments
  class InvestmentsController < ApplicationController
    before_action :authenticate_user!

    def index
      @investments = Investments::FetchInvestments.call(current_user.id)

      serialized_investments = Investments::InvestmentListSerializer
                               .new(@investments)
                               .serializable_hash[:data]

      render json: serialized_investments, status: :ok
    end
  end
end
