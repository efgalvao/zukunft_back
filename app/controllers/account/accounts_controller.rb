module Account
  class AccountsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_account, only: %i[update destroy show]

    def index
      @accounts = Account.where(user_id: current_user.id).except_card_accounts.order(name: :asc)

      render json: @accounts, status: :ok
    end

    def show
      render json: @account, status: :ok
    end

    def create
      @account = ::Account::CreateAccount.call(account_params)

      if @account.valid?
        render json: @account, status: :created
      else
        render json: @account.errors, status: :unprocessable_entity
      end
    end

    def update
      if @account.update(name: params[:account][:name], kind: params[:account][:kind])
        render json: @account, status: :ok
      else
        render json: @account.errors, status: :unprocessable_entity
      end
    end

    def brokers
      @accounts = Account.where(user_id: current_user.id).broker_accounts.order(name: :asc)
    end

    def destroy
      @account.destroy
      render json: { 'status': ' ok' }, status: :ok
    end

    private

    def set_account
      @account = Account.find(params[:id])
    end

    def account_params
      params.require(:account).permit(:name, :balance_cents, :kind).merge(user_id: current_user.id)
    end
  end
end
