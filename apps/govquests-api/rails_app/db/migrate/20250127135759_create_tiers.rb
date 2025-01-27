class CreateTiers < ActiveRecord::Migration[8.1]
  def change
    create_table :tiers do |t|
      t.string :tier_id, null: false
      t.jsonb :display_data, null: false
      t.timestamps
    end

    add_index :tiers, :tier_id, unique: true
  end
end
