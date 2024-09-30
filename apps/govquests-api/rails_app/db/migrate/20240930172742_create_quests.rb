class CreateQuests < ActiveRecord::Migration[8.0]
  def change
    create_table :quests do |t|
      t.string :quest_id

      t.timestamps
    end
  end
end
