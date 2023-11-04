module Investments
  class CreateNegotiation < ApplicationService
    def initialize(params)
      @kind = params[:kind]
      @value = params[:value]
      @date = params[:date]
      @shares = params[:shares].to_i
      @parent_id = params[:parent_id]
      @parent_kind = params[:parent_kind]
    end

    def self.call(params)
      new(params).call
    end

    def call
      record = if parent_kind == 'stock'
                 stock.negotiations.new(negotiation_params)
               else
                 treasury.negotiations.new(negotiation_params)
               end

      ActiveRecord::Base.transaction do
        Transactions::RequestTransaction.call(transaction_params)
        Investments::Stock::UpdateStock.call(update_stock_params)
        record.save
      end

      record
    end

    private

    attr_reader :kind, :value, :shares, :date, :parent_id, :parent_kind

    def stock
      @stock ||= Investments::Stock::Stock.find(parent_id)
    end

    def treasury
      @treasury ||= Investments::Treasury::Treasury.find(parent_id)
    end

    def negotiation_params
      {
        kind: kind,
        date: date,
        invested_cents: value_in_cents,
        shares: shares
      }
    end

    def transaction_params
      {
        title: "Negociação de #{parent_kind}",
        value: value,
        kind: 'investment',
        account_id: stock.account_id,
        date: date
      }
    end

    def update_stock_params
      {
        date: date,
        quantity: shares,
        invested: value_in_cents,
        stock_id: stock.id
      }
    end

    def value_in_cents
      value.to_f * 100
    end
  end
end
