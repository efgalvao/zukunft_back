module Users
  class TransferencesController < ApplicationController
    before_action :authenticate_user!

    def index
      @transferences = Transferences::RetrieveTransference.call(current_user.id)
      render json: @transferences, status: :ok
    end

    def create
      @transference = Transferences::CreateTransference.call(transference_params)
      render json: @transference, status: :created
    end

    private

    def transference_params
      params.require(:transference).permit(:sender, :receiver, :value, :date)
            .merge(user_id: current_user.id)
    end
  end
end
