module Types
  class QuestType < Types::BaseObject
    field :id, ID, null: false, method: :quest_id
    field :audience, String, null: false
    field :slug, String, null: false
    field :status, String, null: false
    field :display_data, Types::DisplayDataType, null: false
    field :actions, [Types::ActionType], null: false
    field :user_quests, [Types::UserQuestType], null: false
    field :reward_pools, [Types::RewardPoolType], null: false
    field :badge, Types::BadgeType, null: true
    field :track, Types::TrackType, null: true

    def actions
      object.quest_actions.order(:position).map(&:action)
    end

    def user_quests
      object.user_quests.where(user: context[:current_user])
    end
  end
end
