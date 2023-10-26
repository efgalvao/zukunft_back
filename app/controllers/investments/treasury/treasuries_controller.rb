module Investments
  module Treasury
    class TreasuriesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_treasury, only: %i[show update destroy]

      def index
        treasuries = Investments::Treasury::Treasury
                     .joins(:account)
                     .where(account: { user_id: current_user.id }, account_id: params[:treasury][:account_id])
                     .order(name: :asc)

        serialized_treasuries = Investments::Treasury::TreasurySerializer
                                .new(treasuries)
                                .serializable_hash[:data]

        render json: serialized_treasuries, status: :ok
      end

      def create
        treasury = Investments::Treasury::CreateTreasury.call(treasury_params)
        if treasury.valid?
          serialized_treasury = Investments::Treasury::TreasurySerializer
                                .new(treasury, { include: %i[negotiations prices] })
                                .serializable_hash[:data]

          render json: serialized_treasury, status: :created
        else
          render json: { errors: treasury.errors.full_messages.to_sentence },
                 status: :unprocessable_entity
        end
      end

      def show
        serialized_treasury = Investments::Treasury::TreasurySerializer
                              .new(@treasury)
                              .serializable_hash[:data]

        render json: serialized_treasury, status: :ok
      end

      def update
        @treasury = Investments::Treasury::UpdateTreasury
                    .call(treasury_params.merge(treasury_id: @treasury.id))

        if @treasury.valid?
          serialized_treasury = Investments::Treasury::TreasurySerializer
                                .new(@treasury, { include: %i[negotiations prices] })
                                .serializable_hash[:data]

          render json: serialized_treasury, status: :ok
        else
          render json: { errors: @treasury.errors.full_messages.to_sentence },
                 status: :unprocessable_entity
        end
      end

      def destroy
        @treasury.destroy
        render json: { 'status': ' ok' }, status: :ok
      end

      private

      def set_treasury
        @treasury = Investments::Treasury::Treasury
                    .includes(:prices, :negotiations)
                    .order('negotiations.date ASC')
                    .order('prices.date ASC')
                    .find(params[:id])
                    .tap { |treasury| treasury.negotiations = treasury.negotiations.last(6) }
      end

      def treasury_params
        params.require(:treasury).permit(:name, :account_id, :invested_value_cents,
                                         :current_value_cents)
      end
    end
  end
end
