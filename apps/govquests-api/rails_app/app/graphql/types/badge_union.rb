module Types
  class BadgeUnion < Types::BaseUnion
    possible_types Types::BadgeType, Types::SpecialBadgeType

    def self.resolve_type(object, context)
      case object
      when Gamification::BadgeReadModel
        Types::BadgeType
      when Gamification::SpecialBadgeReadModel
        Types::SpecialBadgeType
      else
        raise "Unexpected badge type: #{object.class}"
      end
    end
  end
end
