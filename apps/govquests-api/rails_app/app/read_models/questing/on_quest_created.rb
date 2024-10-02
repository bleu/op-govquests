module Questing
  class OnQuestCreated
    def call(event)
      quest_id = event.data.fetch(:quest_id)
      audience = event.data.fetch(:audience)
      quest_type = event.data.fetch(:quest_type)
      duration = event.data.fetch(:duration)
      difficulty = event.data.fetch(:difficulty)
      requirements = event.data[:requirements] || []
      reward = event.data[:reward] || {}
      subquests = event.data[:subquests] || []

      Quest.find_or_create_by(quest_id: quest_id).update(
        audience: audience,
        quest_type: quest_type,
        duration: duration,
        difficulty: difficulty,
        requirements: requirements,
        reward: reward,
        subquests: subquests,
        status: "created"
      )
    end
  end
end
