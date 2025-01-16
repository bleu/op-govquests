module Gamification
  class UserBadgeReadModel < ApplicationRecord
    self.table_name = "user_badges"

    belongs_to :user
    belongs_to :badgeable, polymorphic: true

    validates :user_id, presence: true
    validates :earned_at, presence: true

    validate :validate_uniqueness_for_normal_badges

    scope :special, -> { where(badgeable_type: "Gamification::SpecialBadgeReadModel") }
    scope :normal, -> { where(badgeable_type: "Gamification::BadgeReadModel") }
    scope :earned_between, ->(start_date, end_date) { where(earned_at: start_date..end_date) }
    scope :ordered_by_earned, -> { order(earned_at: :desc) }

    def special?
      badgeable_type == "Gamification::SpecialBadgeReadModel"
    end

    def normal?
      badgeable_type == "Gamification::BadgeReadModel"
    end

    private

    def validate_uniqueness_for_normal_badges
      return unless normal?

      if UserBadgeReadModel.exists?(
        user_id: user_id,
        badgeable_type: badgeable_type,
        badgeable_id: badgeable_id
      )
        errors.add(:base, "User already has this normal badge")
      end
    end
  end
end
