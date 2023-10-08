module Transferences
  class BuildStatement < ApplicationService
    def initialize(user_id)
      @user_id = user_id
    end

    def self.build(user_id)
      new(user_id).build
    end

    def build
      build_payload
    end

    private

    attr_reader :user_id

    def serialized_transferences(transferences)
      ::Users::TransferenceSerializer.new(transferences).serializable_hash[:data]
    end

    def build_payload
      {
        future_transferences: serialized_transferences(future_transferences).map { |t| t[:attributes] },
        past_transferences: serialized_transferences(past_transferences).map { |t| t[:attributes] }
      }
    end

    def future_transferences
      Transference.where(user_id: user_id).where('date > ?', Time.zone.today).order(date: :asc)
    end

    def past_transferences
      Transference.where(user_id: user_id).where('date <= ?', Time.zone.today).order(date: :desc)
    end
  end
end
