module Gamification
  module Types
    class ClaimMetadata < Dry::Struct
      attribute :transaction_metadata, Infra::Types::Hash.optional
      attribute :user_address, Infra::Types::String
    end
  end
end
