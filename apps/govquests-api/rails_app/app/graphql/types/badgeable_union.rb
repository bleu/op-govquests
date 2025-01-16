module Types
  class BadgeableUnion < Types::BaseUnion
    possible_types Types::QuestType, Types::TrackType # Add all your badgeable types here

    def self.resolve_type(object, context)
      case object
      when Questing::QuestReadModel
        Types::QuestType
      when Questing::TrackReadModel
        Types::TrackType
      else
        raise "Unknown badgeable type: #{object.class}"
      end
    end
  end
end
