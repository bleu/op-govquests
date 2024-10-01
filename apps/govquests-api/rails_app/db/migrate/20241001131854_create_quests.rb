class CreateQuests < ActiveRecord::Migration[8.0]
  def change
    create_table :quests do |t|
      t.string :img_url
      t.string :title
      t.string :reward_type
      t.text :intro
      t.text :steps

      t.timestamps
    end
  end
end
