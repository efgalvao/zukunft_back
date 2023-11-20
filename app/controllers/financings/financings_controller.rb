module Financings
  class FinancingsController < ApplicationController
    before_action :authenticate_user!
    before_action :financing, only: %i[show delete]

    def index
      @financings = Financings::Financing.where(user_id: current_user.id).all

      serialized_financings = FinancingSerializer.new(@financings).serializable_hash[:data]

      render json: serialized_financings, status: :ok
    end

    def create
      @financing = Financings::CreateFinancing.call(financing_params)
      if @financing.valid?
        serialized_financing = FinancingSerializer.new(@financing).serializable_hash[:data][:attributes]

        render json: serialized_financing, status: :created
      else
        render json: @financing.errors.full_messages, status: :unprocessable_entity
      end
    end

    def show
      serialized_financing = FinancingSerializer.new(@financing).serializable_hash[:data][:attributes]

      render json: serialized_financing, status: :ok
    end

    def delete
      @financing.destroy
      render json: { 'status': ' ok' }, status: :ok
    end

    private

    def financing
      @financing ||= Financing
                     .find_by(id: params[:id], user_id: current_user.id)
    end

    def financing_params
      params.require(:financing)
            .permit(:name, :borrowed_value, :installments)
            .merge(user_id: current_user.id)
    end
  end
end
