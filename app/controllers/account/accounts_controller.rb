module Account
  class AccountsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_account, only: %i[update destroy show]

    def index
      @accounts = Account.where(user_id: current_user.id).except_card_accounts.order(name: :asc)

      serialized_accounts = AccountSerializer.new(@accounts).serializable_hash[:data]
      render json: serialized_accounts, status: :ok
    end

    def show
      serialized_account = AccountSerializer.new(@account).serializable_hash[:data]
      render json: serialized_account, status: :ok
    end

    def create
      @account = ::Account::CreateAccount.call(account_params)

      if @account.valid?
        serialized_account = AccountSerializer.new(@account).serializable_hash[:data]
        render json: serialized_account, status: :created
      else
        render json: @account.errors, status: :unprocessable_entity
      end
    end

    def update
      if @account.update(name: params[:account][:name], kind: params[:account][:kind])
        serialized_account = AccountSerializer.new(@account).serializable_hash[:data]
        render json: serialized_account, status: :ok
      else
        render json: @account.errors, status: :unprocessable_entity
      end
    end

    def brokers
      @accounts = Account.where(user_id: current_user.id).broker_accounts.order(name: :asc)

      serialized_accounts = AccountSerializer.new(@accounts).serializable_hash[:data]
      render json: serialized_accounts, status: :ok
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
      params.require(:account).permit(:name, :balance, :kind).merge(user_id: current_user.id)
    end
  end
end
