module Users
  class TransferenceSerializer
    include JSONAPI::Serializer
    attributes :value_cents, :date, :sender_name, :receiver_name
  end
end
