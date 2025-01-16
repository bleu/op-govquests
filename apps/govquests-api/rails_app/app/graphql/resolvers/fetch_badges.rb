module Resolvers
  class FetchBadges < BaseResolver
    type [Types::BadgeType], null: true

    argument :special, Boolean, required: false, default_value: nil

    def resolve(special:)
      case special
      when true
        Gamification::BadgeReadModel.special
      when false
        Gamification::BadgeReadModel.normal
      else
        Gamification::BadgeReadModel.all
      end
    end
  end
end
