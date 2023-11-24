module Account
  class BrokerAccountSerializer
    include JSONAPI::Serializer
    attributes :id, :name, :balance_cents, :kind, :updated_at, :total_balance_cents

    def total_balance_cents
      object.total_balance_cents
    end
  end
end
