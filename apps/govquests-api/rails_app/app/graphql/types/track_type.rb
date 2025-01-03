module Types
  class TrackType < Types::BaseObject
    field :id, ID, null: false, method: :track_id
    field :display_data, Types::TrackDisplayDataType, null: false
    field :quests, [Types::QuestType], null: false
  end
end
