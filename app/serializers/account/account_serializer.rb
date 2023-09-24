module Account
  class AccountSerializer
    include JSONAPI::Serializer
    attributes :name, :balance_cents, :kind, :updated_at
  end
end
