module Types
  class BadgeType < Types::BaseObject
    field :id, ID, null: false, method: :track_id
    field :display_data, Types::TrackDisplayDataType, null: false
  end
end
