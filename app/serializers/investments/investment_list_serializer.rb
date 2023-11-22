module Investments
  class InvestmentListSerializer
    include JSONAPI::Serializer

    attributes :id, :account_name, :account_id, :name, :kind

    attribute :name do |object|
      object.respond_to?(:name) ? object.name : object.ticker
    end

    attribute :kind do |object|
      object.class.name.demodulize
    end
  end
end
