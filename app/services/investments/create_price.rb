module Investments
  class CreatePrice < ApplicationService
    def initialize(params)
      @date = params[:date]
      @value = params[:value].to_f
      @parent_kind = params[:parent_kind]
      @parent_id = params[:parent_id]
    end

    def self.call(params)
      new(params).call
    end

    def call
      ApplicationRecord.transaction do
        create_price

        consolidate_stock
        consolidate_account_report
      end
    end

    private

    attr_reader :date, :value, :parent_kind, :parent_id

    def create_price
      if parent_kind == 'stock'
        stock.prices.create(price_params)
      else
        treasury.prices.create(price_params)
      end
    end

    def stock
      @stock ||= Investments::Stock::Stock.find(parent_id)
    end

    def treasury
      @treasury ||= Investments::Treasury::Treasury.find(parent_id)
    end

    def consolidate_account_report
      AccountReport::UpdateAccountReport.call(account_id: stock.account_id)
    end

    def consolidate_stock
      Investments::Stock::ConsolidateStock.call(stock_id: stock.id)
    end

    def price_params
      {
        date: date,
        value_cents: value_in_cents
      }
    end

    def value_in_cents
      value * 100
    end

    def value_to_update_balance
      value_in_cents * stock.shares_total
    end
  end
end
