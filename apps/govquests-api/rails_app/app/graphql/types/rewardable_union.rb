module Types
  class RewardableUnion < Types::BaseUnion
    possible_types Types::SpecialBadgeType, Types::QuestType

    def self.resolve_type(object, _context)
      case object
      when Gamification::SpecialBadgeReadModel
        Types::SpecialBadgeType
      when Questing::QuestReadModel
        Types::QuestType
      else
        raise "Unknown rewardable type: #{object.class}"
      end
    end
  end
end
