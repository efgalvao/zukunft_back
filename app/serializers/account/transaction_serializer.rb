module Account
  class TransactionSerializer
    include JSONAPI::Serializer
    attributes :id, :title, :account_id, :category_id, :value_cents, :kind, :date
  end
end
