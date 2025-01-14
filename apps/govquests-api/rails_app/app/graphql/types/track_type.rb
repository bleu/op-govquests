module Types
  class TrackType < Types::BaseObject
    field :id, ID, null: false, method: :track_id
    field :display_data, Types::TrackDisplayDataType, null: false
    field :quests, [Types::QuestType], null: false
    field :points, Integer, null: false
    field :badge, Types::BadgeType, null: true
    field :is_completed, Boolean, null: false

    def points
      object.quests.includes(:reward_pools).sum do |quest|
        quest.reward_pools.where("reward_definition->>'type' = ?", "Points").sum("(reward_definition->>'amount')::integer")
      end
    end

    def is_completed
      object.quests.joins(:user_quests)
        .where(user_quests: { user: context[:current_user], status: "completed" })
        .count == object.quests.count
    end
  end
end
