module Types
  class QuestType < Types::BaseObject
    field :id, ID, null: false, method: :quest_id
    field :quest_type, String, null: false
    field :audience, String, null: false
    field :status, String, null: false
    field :rewards, [Types::RewardType], null: false
    field :display_data, Types::DisplayDataType, null: false
    field :actions, [Types::ActionType], null: false

    def actions
      object.quest_actions.order(:position).map(&:action)
    end
  end
end