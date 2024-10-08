module Infra
  module Types
    include Dry.Types
    UUID =
      Types::Strict::String.constrained(
        format: /^\h{8}-(\h{4}-){3}\h{12}$/
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
