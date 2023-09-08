module Investments
  class CreateNegotiation < ApplicationService
    def initialize(params)
      @kind = params[:kind]
      @value = params[:value].to_f
      @date = params[:date]
      @shares = params[:shares].to_i
      @parent_id = params[:parent_id]
      @parent_kind = params[:parent_kind]
    end

    def self.call(params)
      new(params).call
    end

    def call
      if parent_kind == 'stock'
        record = stock.negotiations.new(negotiation_params)
      else
        []
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
        value: value_in_cents,
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
      value * 100
    end
  end
end
