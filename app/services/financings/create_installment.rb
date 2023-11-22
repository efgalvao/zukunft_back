module Financings
  class CreateInstallment
    def initialize(params)
      @params = params
    end

    def self.call(params)
      new(params).call
    end

    def call
      installment = Installment.new(installment_params)
      installment.save
      installment
    end

    private

    attr_reader :params

    def installment_params
      {
        financing_id: params[:financing_id],
        ordinary: params[:ordinary],
        parcel: params[:parcel],
        paid_parcels: params[:paid_parcels],
        payment_date: params[:payment_date],
        amortization_cents: value_to_cents(params[:amortization]),
        interest_cents: value_to_cents(params[:interest]),
        insurance_cents: value_to_cents(params[:insurance]),
        fees_cents: value_to_cents(params[:fees]),
        monetary_correction_cents: value_to_cents(params[:monetary_correction]),
        adjustment_cents: value_to_cents(params[:adjustment])
      }
    end

    def value_to_cents(value)
      (value.to_f * 100).to_i
    end
  end
end
