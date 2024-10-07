class AddSaltToActionExecutions < ActiveRecord::Migration[8.0]
  def change
    change_table :action_executions do |t|
      t.string :salt, null: false
    end
  end
end
