module Gamification
  class GameProfileReadModel < ApplicationRecord
    self.table_name = "user_game_profiles"

    attribute :tier, :string
  end
end

# == Schema Information
#
# Table name: user_game_profiles
#
#  id         :bigint           not null, primary key
#  badges     :jsonb
#  score      :integer          default(0)
#  streak     :integer          default(0)
#  tier       :integer          default("0")
#  track      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  profile_id :string           not null
#
# Indexes
#
#  index_user_game_profiles_on_profile_id  (profile_id) UNIQUE
#
