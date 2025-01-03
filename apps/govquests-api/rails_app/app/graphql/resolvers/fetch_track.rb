module Resolvers
  class FetchTrack < BaseResolver
    type Types::TrackType, null: true

    argument :id, ID, required: true

    def resolve(id:)
      Tracking::Queries::FindTrack.call(id)
    end
  end
end
