module Types
  class UserQuestType < Types::BaseObject
    field :id, ID, null: false, method: :user_quest_id
    field :status, String, null: false
    field :started_at, GraphQL::Types::ISO8601DateTime, null: true
    field :completed_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end
