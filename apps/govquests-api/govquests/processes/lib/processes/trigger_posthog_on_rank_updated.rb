module Processes
  class TriggerPosthogOnRankUpdated
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [Gamification::GameProfileRankUpdated])
    end

    def call(event)
      profile_id = event.data[:profile_id]
      rank = event.data[:rank]
      
      previous_rank = game_profile_previous_rank(profile_id)

      if previous_rank.nil?
        return
      end

      PosthogTrackingService.track_event("leaderboard_position_changed", {
        position: rank,
        previous_position: previous_rank,
        user_id: profile_id
      }, profile_id)
    end

    private

    def game_profile_previous_rank(profile_id)
      stream_name = "Gamification::GameProfile$#{profile_id}"
      events = @event_store.read.stream(stream_name).to_a

      return nil if events.empty?

      previous_ranks = events.find_all { |event| event.is_a?(Gamification::GameProfileRankUpdated) }

      sorted_ranks = previous_ranks.sort_by { |event| event.metadata[:timestamp] }
      if sorted_ranks.length <= 1
        return nil
      end

      sorted_ranks[-2].data[:rank]
    end
  end
end