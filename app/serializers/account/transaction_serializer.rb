module Account
  class TransactionSerializer
    include JSONAPI::Serializer
    attributes :title, :category_id, :value_cents, :kind, :date
  end
end
