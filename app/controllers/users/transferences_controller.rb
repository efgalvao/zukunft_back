module Users
  class TransferencesController < ApplicationController
    def index
      @transferences = Transference::RetrieveTransference.call(current_user.id)
      render json: @transferences, status: :ok
    end

    def create
      @transference = Transference::CreateTransference.call(transference_params)
      render json: @transference, status: :created
    end

    private

    def transference_params
      params.requirer(:transference).permit(:sender_id, :receiver_id, :value, :date)
            .merge(user_id: current_user.id)
    end
  end
end
