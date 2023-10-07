module Users
  class TransferenceSerializer
    include JSONAPI::Serializer
    attributes :value_cents, :date, :sender, :receiver

    def sender
      object.sender.name
    end

    def receiver
      object.receiver.name
    end
  end
end
