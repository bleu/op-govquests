class CreateUserBadges < ActiveRecord::Migration[8.1]
  def change
    create_table :user_badges do |t|
      t.string :user_id, null: false
      t.string :badge_type, null: false
      t.string :badge_id, null: false
      t.datetime :earned_at, null: false
      t.timestamps
    end

    add_index :user_badges, [:badge_type, :badge_id]
    add_index :user_badges, :earned_at

    # Optional: Add a partial unique index for normal badges
    add_index :user_badges, [:user_id, :badge_type, :badge_id],
      unique: true,
      where: "badge_type = 'Gamification::BadgeReadModel'",
      name: 'unique_normal_badges_index'
  end
end
