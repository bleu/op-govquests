module Gamification
class GameProfileReadModel < ApplicationRecord
    self.table_name = "user_game_profiles"

    attribute :tier, :string
  end
end