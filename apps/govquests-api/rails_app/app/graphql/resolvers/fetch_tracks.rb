module Resolvers
  class FetchTracks < BaseResolver
    type [Types::TrackType], null: true

    def resolve
      Questing::Queries::AllTracks.call
    end
  end
end
