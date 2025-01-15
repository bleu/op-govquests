module Types
  class BadgeType < Types::BaseObject
    field :id, ID, null: false, method: :badge_id
    field :display_data, Types::BadgeDisplayDataType, null: false
    field :badgeable, Types::BadgeableUnion, null: false
  end
end
