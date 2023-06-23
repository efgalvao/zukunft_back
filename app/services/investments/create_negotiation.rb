module Investments
  class CreateNegotiation < ApplicationService
    def initialize(params)
      @params = params
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

    attr_reader :params

    def stock
      @stock ||= Investments::Stock::Stock.find(params[:parent_id])
    end

    # def treasury
    #   @treasury ||= Investments::Treasury::Treasury.find(params[:parent_id])
    # end

    def negotiation_params
      {
        kind: params[:kind],
        date: params[:date],
        invested_cents: (params[:invested_cents].to_f * 100).to_i,
        shares: params[:shares]
      }
    end
  end
end
