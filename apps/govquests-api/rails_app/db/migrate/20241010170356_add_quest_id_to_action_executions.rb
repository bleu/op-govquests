class AddQuestIdToActionExecutions < ActiveRecord::Migration[8.0]
  def change
    change_table :action_executions do |t|
      t.string :quest_id, null: false
    end
  end
end
