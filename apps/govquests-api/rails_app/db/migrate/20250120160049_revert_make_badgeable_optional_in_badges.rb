class RevertMakeBadgeableOptionalInBadges < ActiveRecord::Migration[8.1]
  def change
    change_column_null :badges, :badgeable_type, false
    change_column_null :badges, :badgeable_id, false

    remove_index :badges, [:badgeable_type, :badgeable_id]
    add_index :badges, [:badgeable_type, :badgeable_id], unique: true
  end
end
