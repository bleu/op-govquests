module Infra
  module Types
    include Dry.Types
    UUID =
      Types::Strict::String.constrained(
        format: /\A[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}\z/i
      )
    ID = Types::Strict::Integer
    Metadata =
      Types::Hash.schema(
        timestamp: Types::Time.meta(omittable: true)
      )
    Quantity = Types::Strict::Integer.constrained(gt: 0)
    Price = Types::Coercible::Decimal.constrained(gt: 0)
    Value = Types::Coercible::Decimal
  end
end
