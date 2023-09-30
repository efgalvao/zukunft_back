module Account
  class AccountSerializer
    include JSONAPI::Serializer
    attributes :id, :name, :balance_cents, :kind, :updated_at
  end
end
