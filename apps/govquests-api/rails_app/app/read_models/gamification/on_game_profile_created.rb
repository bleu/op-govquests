module Gamification
  class OnGameProfileCreated
    def call(event)
      GameProfileReadModel.create!(
        profile_id: event.data[:profile_id]
      )
    end
  end
end
