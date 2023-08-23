module Investments
  class CreateNegotiation < ApplicationService
    def initialize(params)
      @kind = params[:parent_kind]
      @invested_cents = params[:value_cents].to_f * 100
      @parent_id = params[:parent_id]
      @date = params[:date]
    end

    def self.call(params)
      new(params).call
    end

    def call
      if params[:parent_kind] == 'stock'
        negotiation = stock.negotiations.new(negotiation_params)
      else
        []
        # TODO: Implement treasuries
        # price = treasury.prices.new(price_params)
      end

      ActiveRecord::Base.transaction do
        Transactions::ProcessTransaction.call(transactions_params)
        Investments::Stock::UpdateStock.call(update_stock_params)
        negotiation.save!
      end

      if negotiation.valid?
        price
      else
        negotiation.errors
      end
    end

    private

    attr_reader :kind, :invested_cents, :shares, :date

    def stock
      @stock ||= Investments::Stock::Stock.find(params[:parent_id])
    end

    # def treasury
    #   @treasury ||= Investments::Treasury::Treasury.find(params[:parent_id])
    # end

    def negotiation_params
      {
        kind: kind,
        date: date,
        invested_cents: invested_cents,
        shares: shares
      }
    end
  end
end
