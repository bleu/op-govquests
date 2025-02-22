class CreateQuests < ActiveRecord::Migration[8.0]
  def change
    create_table :quests do |t|
      t.string :quest_id, null: false, index: {unique: true}
      t.string :audience, null: false
      t.string :status, null: false
      t.jsonb :display_data, null: false, default: {}
      t.timestamps
    end
  end
end
