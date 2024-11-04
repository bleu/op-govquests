class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.string :notification_id, null: false
      t.string :user_id, null: false
      t.string :content, null: false
      t.string :notification_type, null: false
      t.timestamps
    end

    create_table :notification_deliveries do |t|
      t.string :notification_id, null: false
      t.string :delivery_method, null: false
      t.string :status, null: false, default: "pending"
      t.datetime :delivered_at
      t.datetime :read_at
      t.jsonb :metadata, default: {}

      t.timestamps
    end

    add_index :notifications, :notification_id, unique: true
    add_index :notifications, :user_id
    add_index :notification_deliveries, :notification_id
    add_index :notification_deliveries, [:notification_id, :delivery_method], unique: true
  end
end
