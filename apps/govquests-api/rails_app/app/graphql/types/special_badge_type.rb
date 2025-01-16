module Types
  class SpecialBadgeType < Types::BaseObject
    field :id, ID, null: false, method: :badge_id
    field :display_data, Types::BadgeDisplayDataType, null: false
    field :points, Integer, null: false
    field :badge_type, String, null: false
  end
end
