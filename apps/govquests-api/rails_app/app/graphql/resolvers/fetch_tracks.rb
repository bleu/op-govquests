module Resolvers
  class FetchTracks < BaseResolver
    type [Types::TrackType], null: true

    def resolve
      Tracking::Queries::AllTracks.call
    end
  end
end
