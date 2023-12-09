module Account
  class AccountSerializer
    include JSONAPI::Serializer
    attributes :id, :name, :balance_cents, :kind, :updated_at, :balance_plus_invested_cents,
               :invested_cents, :current_invested_cents

    attribute :balance_plus_invested_cents do |object|
      object.treasuries.where(released: false).sum(:current_value_cents) +
        object.stocks.sum(:current_total_value_cents) +
        object.balance_cents
    end

    attribute :invested_cents do |object|
      object.stocks.sum(:invested_value_cents) +
        object.treasuries.sum(:invested_value_cents)
    end

    attribute :current_invested_cents do |object|
      object.stocks.sum(:current_total_value_cents) +
        object.treasuries.sum(:current_value_cents)
    end
  end
end
