class CreateSpecialBadges < ActiveRecord::Migration[8.1]
  def change
    create_table :special_badges do |t|
      t.string :badge_id, null: false
      t.jsonb :display_data, null: false
      t.string :badge_type, null: false
      t.jsonb :badge_data, null: false
      t.integer :points, null: false
      t.timestamps
    end

    add_index :special_badges, :badge_id, unique: true
  end
end
