module Gamification
  class BadgeReadModel < ApplicationRecord
    self.table_name = "badges"

    belongs_to :badgeable, polymorphic: true, optional: true

    validates :badge_id, presence: true, uniqueness: true
    validates :display_data, presence: true
    validate :validate_badgeable_consistency

    def special?
      badgeable_id.nil? && badgeable_type.nil?
    end

    scope :special, -> { where(badgeable_type: nil, badgeable_id: nil) }
    scope :normal, -> { where.not(badgeable_type: nil, badgeable_id: nil) }

    private

    def validate_badgeable_consistency
      if (badgeable_type.present? && badgeable_id.nil?) ||
          (badgeable_type.nil? && badgeable_id.present?)
        errors.add(:base, "Both badgeable type and ID must be present, or both must be nil")
      end
    end
  end
end

# == Schema Information
#
# Table name: badges
#
#  id             :bigint           not null, primary key
#  badgeable_type :string
#  display_data   :jsonb            not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  badge_id       :string           not null
#  badgeable_id   :string
#
# Indexes
#
#  index_badges_on_badge_id                         (badge_id) UNIQUE
#  index_badges_on_badgeable_type_and_badgeable_id  (badgeable_type,badgeable_id) UNIQUE WHERE ((badgeable_type IS NOT NULL) AND (badgeable_id IS NOT NULL))
#
