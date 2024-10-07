class AddCompletionDataToActionExecution < ActiveRecord::Migration[8.0]
  def change
    change_table :action_executions do |t|
      t.jsonb :start_data, default: {}, null: false
      t.jsonb :completion_data, default: {}, null: false
    end
  end
end
