module Gamification
  class OnGameProfileCreated
    def call(event)
      GameProfileReadModel.create!(
        profile_id: event.data[:profile_id],
        tier_id: event.data[:tier_id]
      )
    end
  end
end
