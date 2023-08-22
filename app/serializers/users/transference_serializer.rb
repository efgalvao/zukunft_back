module Users
  class TransferenceSerializer
    include JSONAPI::Serializer
    attributes :sender_id, :receiver_id, :value_cents, :date
  end
end
