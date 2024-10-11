class AddUserQuestIdToUserQuests < ActiveRecord::Migration[8.0]
  def change
    change_table :user_quests do |t|
      t.string :user_quest_id, null: false, index: {unique: true}
    end
  end
end
