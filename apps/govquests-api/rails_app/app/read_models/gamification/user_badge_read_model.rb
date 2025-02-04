module Gamification
  class UserBadgeReadModel < ApplicationRecord
    self.table_name = "user_badges"

    belongs_to :user, class_name: "Authentication::UserReadModel", foreign_key: "user_id", primary_key: "user_id"
    belongs_to :badge, polymorphic: true

    validates :user_id, presence: true
    validates :earned_at, presence: true

    default_scope { ordered_by_earned }

    scope :special, -> { where(badge_type: "Gamification::SpecialBadgeReadModel") }
    scope :normal, -> { where(badge_type: "Gamification::BadgeReadModel") }
    scope :earned_between, ->(start_date, end_date) { where(earned_at: start_date..end_date) }
    scope :ordered_by_earned, -> { order(earned_at: :desc) }

    def special?
      badge_type == "Gamification::SpecialBadgeReadModel"
    end

    def normal?
      badge_type == "Gamification::BadgeReadModel"
    end
  end
end

# == Schema Information
#
# Table name: user_badges
#
#  id         :bigint           not null, primary key
#  badge_type :string           not null
#  earned_at  :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  badge_id   :string           not null
#  user_id    :string           not null
#
# Indexes
#
#  index_user_badges_on_badge_type_and_badge_id  (badge_type,badge_id)
#  index_user_badges_on_earned_at                (earned_at)
#  unique_normal_badges_index                    (user_id,badge_type,badge_id) UNIQUE WHERE ((badge_type)::text = 'Gamification::BadgeReadModel'::text)
#
