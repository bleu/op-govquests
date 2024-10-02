class CreateQuests < ActiveRecord::Migration[8.0]
  def change
    create_table :quests do |t|
      t.string :quest_id, null: false, index: {unique: true}
      t.string :audience, null: false
      t.string :quest_type, null: false
      t.integer :duration, null: false
      t.string :difficulty, null: false
      t.jsonb :requirements, default: []
      t.jsonb :reward, default: {}
      t.jsonb :subquests, default: []
      t.string :status, default: "created"
      t.timestamps
    end
  end
end
