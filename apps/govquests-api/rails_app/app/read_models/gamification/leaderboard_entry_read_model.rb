module Gamification
  class LeaderboardEntryReadModel < ApplicationRecord
    self.table_name = "leaderboard_entries"
    query_constraints :leaderboard_id, :profile_id

    belongs_to :leaderboard,
      foreign_key: "leaderboard_id",
      primary_key: "leaderboard_id",
      class_name: "Gamification::LeaderboardReadModel",
      inverse_of: :leaderboard_entries

    validates :rank, presence: true
    validates :score, presence: true
  end
end

# == Schema Information
#
# Table name: leaderboard_entries
#
#  rank           :integer          not null
#  score          :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  leaderboard_id :string           not null
#  profile_id     :string           not null
#
# Indexes
#
#  index_leaderboard_entries_on_leaderboard_id_and_profile_id  (leaderboard_id,profile_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (leaderboard_id => leaderboards.leaderboard_id)
#
