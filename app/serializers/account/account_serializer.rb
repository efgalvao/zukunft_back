module Account
  class AccountSerializer
    include JSONAPI::Serializer
    attributes :name, :balance_cents, :updated_at
  end
end
