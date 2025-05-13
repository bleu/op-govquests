class AddStatusToRewardIssuances < ActiveRecord::Migration[8.1]
  def change
    add_column :reward_issuances, :status, :string, default: "completed"
    add_column :reward_issuances, :confirmed_at, :datetime

    remove_column :reward_issuances, :claim_started_at
    remove_column :reward_issuances, :claim_completed_at
  end
end
