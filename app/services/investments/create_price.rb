module Investments
  class CreatePrice < ApplicationService
    def initialize(params)
      @params = params
    end

    def self.call(params)
      new(params).call
    end

    def call
      ApplicationRecord.transaction do
        create_price

        update_stock
        update_account_balance
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

    def create_price
      if params[:parent_kind] == 'stock'
        stock.prices.new(price_params)
      else
        []
        # TODO: Implement treasuries
        # price = treasury.prices.new(price_params)
      end
    end

    def update_stock
      # TODO
      ActiveRecord::Base.transaction do
        stock.shares_total += quantity.to_i
        stock.invested_value_cents += invested
        stock.current_value_cents = new_current_value_cents
        stock.current_total_value_cents = new_current_total_value_cents

        stock.save!
      end
    end

    def update_account_balance
      # TODO
    end

    def price_params
      {
        date: params[:date],
        value_cents: (params[:value_cents].to_f * 100).to_i
      }
    end
  end
end
