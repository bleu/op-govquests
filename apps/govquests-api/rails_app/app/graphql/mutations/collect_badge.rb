module Mutations
  class CollectBadge < BaseMutation
    argument :badge_id, ID, required: true
    argument :badge_type, String, required: true, description: "Type of the badge"

    field :badge_earned, Boolean, null: true
    field :errors, [String], null: false

    def resolve(badge_id:, badge_type:)
      badge = Gamification::SpecialBadgeReadModel.find_by(badge_id: badge_id)

      unless badge
        return {badge_earned: false, errors: ["Badge not found"]}
      end

      Rails.configuration.command_bus.call(
        Gamification::CollectSpecialBadge.new(
          badge_id: badge_id,
          user_id: context[:current_user].user_id
        )
      )

      {
        badge_earned: true,
        errors: []
      }
    rescue Gamification::SpecialBadge::VerificationFailedError
      {
        badge_earned: false,
        errors: ["Sorry, you haven't met the requirements. Try again another time."]
      }
    rescue => e
      {
        badge_earned: false,
        errors: [e.message]
      }
    end
  end
end
