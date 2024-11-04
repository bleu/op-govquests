module SharedKernel
  module Types
    include Dry.Types()

    class RewardDefinition < Dry::Struct
      ALLOWED_TYPES = %w[Token Points].freeze

      attribute :type, Types::String.enum(*ALLOWED_TYPES)
      attribute :amount, Types::Integer
      attribute :token_address, Types::String.optional.default(nil)
    end
  end
end
