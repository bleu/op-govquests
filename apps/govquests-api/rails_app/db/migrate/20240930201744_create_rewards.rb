class CreateRewards < ActiveRecord::Migration[8.0]
  def change
    create_table :rewards do |t|
      t.string :reward_id, null: false, index: { unique: true }
      t.string :reward_type, null: false
      t.integer :value, null: false
      t.datetime :expiry_date
      t.string :issued_to
      t.string :delivery_status, default: "Pending"
      t.boolean :claimed, default: false
      t.timestamps
    end
  end
end
