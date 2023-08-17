module Account
  class AccountSerializer
    include JSONAPI::Serializer
    attributes :name, :balance_cents
  end
end
