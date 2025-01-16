module Gamification
  class UserBadgeReadModel < ApplicationRecord
    self.table_name = "user_badges"

    belongs_to :user, class_name: "Authentication::UserReadModel", foreign_key: "user_id", primary_key: "user_id"
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

# == Schema Information
#
# Table name: user_badges
#
#  id             :bigint           not null, primary key
#  badgeable_type :string           not null
#  earned_at      :datetime         not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  badgeable_id   :string           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_user_badges_on_badgeable_type_and_badgeable_id  (badgeable_type,badgeable_id)
#  index_user_badges_on_earned_at                        (earned_at)
#  index_user_badges_on_user_id                          (user_id)
#  unique_normal_badges_index                            (user_id,badgeable_type,badgeable_id) UNIQUE WHERE ((badgeable_type)::text = 'Gamification::BadgeReadModel'::text)
#
