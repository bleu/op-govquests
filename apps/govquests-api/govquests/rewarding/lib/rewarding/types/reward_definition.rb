module Rewarding
  module Types
    include Dry.Types()

    class RewardDefinition < Dry::Struct
      ALLOWED_TYPES = %w[Token Points].freeze

      attribute :type, Types::String.enum(*ALLOWED_TYPES)
      attribute :amount, Types::Integer.constrained(gt: 0)
      attribute :token_address, Types::String.optional
    end
  end
end
