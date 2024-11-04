class CreateRewardPools < ActiveRecord::Migration[8.1]
  def change
    create_table :reward_pools do |t|
      t.uuid :pool_id, null: false
      t.uuid :quest_id, null: false
      t.jsonb :reward_definition, null: false
      t.integer :remaining_inventory
      t.timestamps

      t.index :pool_id, unique: true
      t.index :quest_id
    end
  end
end
