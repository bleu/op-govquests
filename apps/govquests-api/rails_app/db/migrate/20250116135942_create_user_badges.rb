class CreateUserBadges < ActiveRecord::Migration[8.1]
  def change
    create_table :user_badges do |t|
      t.references :user, null: false
      t.string :badgeable_type, null: false
      t.string :badgeable_id, null: false
      t.datetime :earned_at, null: false
      t.timestamps
    end

    add_index :user_badges, [:badgeable_type, :badgeable_id]
    add_index :user_badges, :earned_at

    # Optional: Add a partial unique index for normal badges
    add_index :user_badges, [:user_id, :badgeable_type, :badgeable_id],
      unique: true,
      where: "badgeable_type = 'Gamification::BadgeReadModel'",
      name: 'unique_normal_badges_index'
  end
end
