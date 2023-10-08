module Users
  class TransferencesController < ApplicationController
    before_action :authenticate_user!

    def index
      serialized_transferences = Transferences::BuildStatement.build(current_user.id)

      render json: serialized_transferences, status: :ok
    end

    def create
      @transference = Transferences::CreateTransference.call(transference_params)

      if @transference.valid?
        serialized_transference = Users::TransferenceSerializer
                                  .new(@transference)
                                  .serializable_hash[:data][:attributes]
        render json: serialized_transference, status: :created
      else
        render json: @transference.errors, status: :unprocessable_entity
      end
    end

    private

    def transference_params
      params.require(:transference).permit(:sender, :receiver, :value, :date)
            .merge(user_id: current_user.id)
    end
  end
end
