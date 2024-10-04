class AddCompletionDataToActionLogs < ActiveRecord::Migration[6.1]
  def change
    add_column :action_logs, :completion_data, :jsonb, default: {}
  end
end
