module Processes
  class TriggerPosthogOnTrackCompleted
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [::Questing::TrackCompleted])
    end

    def call(event)
      user_id = event.data[:user_id]
      track_id = event.data[:track_id]
      return unless track_id

      track = reconstruct_track(track_id)
      track_title = track&.display_data&.dig("title")

      PosthogTrackingService.track_event("track_completed", {
        track_id: track_id,
        track_title: track_title,
        user_id: user_id
      }, user_id)
    end

    private

    def reconstruct_track(track_id)
      stream_name = "Questing::Track$#{track_id}"
      events = @event_store.read.stream(stream_name).to_a

      return nil if events.empty?

      track = OpenStruct.new(display_data: {})

      events.each do |event|
        case event
        when ::Questing::TrackCreated
          track.display_data = event.data[:display_data]
        end
      end

      track
    end
  end
end
