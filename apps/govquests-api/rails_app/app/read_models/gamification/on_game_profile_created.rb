module Gamification
  class OnGameProfileCreated
    def call(event)
      last_rank = GameProfileReadModel.where(tier_id: event.data[:tier_id]).maximum(:rank) || 0

      GameProfileReadModel.create!(
        profile_id: event.data[:profile_id],
        tier_id: event.data[:tier_id],
        rank: last_rank + 1
      )
    end
  end
end
