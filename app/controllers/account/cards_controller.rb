module Account
  class CardsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_card, only: %i[update destroy show]

    def index
      cards = Account.where(user_id: current_user.id).card_accounts.order(name: :asc)

      serialized_cards = AccountSerializer.new(cards).serializable_hash[:data]

      render json: serialized_cards, status: :ok
    end

    def show
      serialized_card = AccountSerializer.new(@card).serializable_hash[:data]

      render json: serialized_card, status: :ok
    end

    def create
      @card = ::Account::CreateAccount.call(card_params)

      if @card.valid?
        serialized_card = AccountSerializer.new(@card).serializable_hash[:data]

        render json: serialized_card, status: :created
      else
        render json: @card.errors, status: :unprocessable_entity
      end
    end

    def update
      if @card.update(name: params[:card][:name])
        serialized_card = AccountSerializer.new(@card).serializable_hash[:data]

        render json: serialized_card, status: :ok
      else
        render json: @card.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @card.destroy
      render json: { 'status': ' ok' }, status: :ok
    end

    private

    def set_card
      @card = Account.find(params[:id])
    end

    def card_params
      params.require(:card).permit(:name, :balance, :kind).merge(user_id: current_user.id)
    end
  end
end
