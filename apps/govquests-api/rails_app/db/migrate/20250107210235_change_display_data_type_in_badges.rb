class ChangeDisplayDataTypeInBadges < ActiveRecord::Migration[8.1]
  def change
    change_column :badges, :display_data, :jsonb, using: 'display_data::jsonb'
  end
end
