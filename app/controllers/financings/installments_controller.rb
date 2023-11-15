module Financings
  class InstallmentsController < ApplicationController
    before_action :authenticate_user!

    def create
      @installment = Financings::CreateInstallment.call(installment_params)

      if @installment.valid?
        render json: { status: 'created' }, status: :created
      else
        render json: @installment.errors.full_messages, status: :unprocessable_entity
      end
    end

    private

    def installment_params
      params.require(:installment)
            .permit(:financing_id, :ordinary, :parcel, :paid_parcels, :payment_date,
                    :amortization, :interest, :insurance, :fees,
                    :monetary_correction, :adjustment)
    end
  end
end
