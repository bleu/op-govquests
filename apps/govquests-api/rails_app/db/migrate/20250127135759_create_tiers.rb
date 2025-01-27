class CreateTiers < ActiveRecord::Migration[8.1]
  def change
    create_table :tiers do |t|
      t.string :tier_id, null: false
      t.jsonb :display_data, null: false
      t.bigint :min_delegation, null: false
      t.bigint :max_delegation
      t.float :multiplier, null: false, default: 1.0
      t.string :image_url
      t.timestamps
    end

    add_index :tiers, :tier_id, unique: true
  end
end
