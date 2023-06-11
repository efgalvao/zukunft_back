module Investments
  class CreatePrice < ApplicationService
    def initialize(params)
      @params = params
    end

    def self.call(params)
      new(params).call
    end

    def call
      if params[:parent_kind] == 'stock'
        price = stock.prices.new(price_params)
      else
        # TODO: Implement treasuries
        # price = treasury.prices.new(price_params)
      end

      if price.save
        price
      else
        price.errors
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

    def price_params
      {
        date: params[:date],
        value_cents: (params[:value_cents].to_f * 100).to_i
      }
    end
  end
end
