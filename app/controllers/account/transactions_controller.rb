module Account
  class TransactionsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_transaction, only: %i[update]

    def index
      account = Account.find_by(id: params[:account_id], user_id: current_user.id)
      @transactions = Transaction.where(account_id: account.id).order(date: :desc)
      render json: @transactions, status: :ok
    end

    def create
      @transaction = Transactions::RequestTransaction.call(transactions_params)

      if @transaction.valid?
        render json: @transaction, status: :created
      else
        render json: @transaction.errors, status: :unprocessable_entity
      end
    end

    def update
      if @transaction.update(update_params)
        render json: @transaction, status: :ok
      else
        render json: @transaction.errors, status: :unprocessable_entity
      end
    end

    private

    def transactions_params
      params.require(:transaction).permit(:title, :category_id, :value, :kind, :date)
            .merge(account_id: params[:account_id])
    end

    def update_params
      params.require(:transaction).permit(:title, :category_id, :date)
    end

    def set_transaction
      @transaction = Transaction.find(params[:id])
    end
  end
end
