module Financings
  class CreateFinancing
    def initialize(params)
      @user_id = params[:user_id]
      @borrowed_value = params[:borrowed_value]
      @installments = params[:installments]
      @name = params[:name]
    end

    def self.call(params)
      new(params).call
    end

    def call
      financing = Financings::Financing.new(financing_attributes)
      financing.save
      financing
    end

    private

    attr_reader :user_id, :borrowed_value, :installments, :name

    def financing_attributes
      {
        name: name,
        user_id: user_id,
        borrowed_value_cents: value_to_cents(borrowed_value),
        installments: installments
      }
    end

    def value_to_cents(value)
      value.to_f * 100
    end
  end
end
