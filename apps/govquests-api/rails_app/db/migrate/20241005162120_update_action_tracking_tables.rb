class UpdateActionTrackingTables < ActiveRecord::Migration[8.0]
  def change
    rename_table :action_logs, :action_executions

    change_table :action_executions do |t|
      t.rename :action_log_id, :execution_id
      t.string :action_type
      t.column :result, :jsonb
      t.rename :executed_at, :started_at
      t.datetime :completed_at
      t.remove :completion_data
    end
  end
end
