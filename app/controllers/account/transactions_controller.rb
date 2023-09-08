module Account
  class TransactionsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_transaction, only: %i[update]

    def index
      account = Account.find_by(id: params[:account_id], user_id: current_user.id)
      transactions = Transaction.where(account_id: account.id).order(date: :desc)

      serialized_transactions = TransactionSerializer.new(transactions).serializable_hash[:data]
      render json: serialized_transactions, status: :ok
    end

    def create
      @transaction = Transactions::RequestTransaction.call(transactions_params)

      if @transaction.valid?
        serialized_transaction = TransactionSerializer.new(@transaction).serializable_hash[:data]
        render json: serialized_transaction, status: :created
      else
        render json: { 'error': @transaction.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    end

    def update
      if @transaction.update(update_params)
        serialized_transaction = TransactionSerializer.new(@transaction).serializable_hash[:data]
        render json: serialized_transaction, status: :ok
      else
        render json: { 'error': @transaction.errors.full_messages.to_sentence }, status: :unprocessable_entity
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
