module Resolvers
  class FetchTrack < BaseResolver
    type Types::TrackType, null: true

    def resolve
      Tracking::Tracks::AllTracks.call
    end
  end
end
