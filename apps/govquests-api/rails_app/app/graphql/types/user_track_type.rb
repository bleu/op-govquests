module Types
  class UserTrackType < Types::BaseObject
    field :id, ID, null: false, method: :user_track_id
    field :status, String, null: false
    field :completed_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end
