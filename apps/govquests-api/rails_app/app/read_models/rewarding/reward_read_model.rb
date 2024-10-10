module Rewarding
class RewardReadModel < ApplicationRecord
    self.table_name = "rewards"

    def description
      display_data["description"]
    end
end