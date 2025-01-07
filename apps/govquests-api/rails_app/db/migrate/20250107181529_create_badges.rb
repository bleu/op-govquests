class CreateBadges < ActiveRecord::Migration[8.1]
  def change
    create_table :badges do |t|
      t.string :badge_id, null: false
      t.string :display_data, null: false
      t.timestamps
    end

    add_index :badges, :badge_id, unique: true
  end
end
