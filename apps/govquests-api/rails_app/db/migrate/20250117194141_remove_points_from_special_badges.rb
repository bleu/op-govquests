class RemovePointsFromSpecialBadges < ActiveRecord::Migration[8.1]
  def change
    remove_column :special_badges, :points, :integer
  end
end
