module Financings
  class InstallmentListSerializer
    include JSONAPI::Serializer

    attributes :financing_name, :amortization_cents, :interest_cents, :insurance_cents,
               :fees_cents, :monetary_correction_cents, :adjustment_cents, :ordinary, :parcel,
               :paid_parcels, :payment_date, :kind
    attribute :financing_name do |object|
      object.financing.name
    end

    attribute :kind do |object|
      object.ordinary ? 'Parcela' : 'Amortização'
    end
  end
end
