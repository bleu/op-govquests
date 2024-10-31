module Authentication
  class UserReadModel < ApplicationRecord
    self.table_name = "users"

    validates :address, presence: true, uniqueness: true
    validates :user_type, presence: true, inclusion: {in: %w[delegate non_delegate]}

    has_many :sessions, class_name: "Authentication::SessionReadModel", foreign_key: :user_id
    has_many :rewards,
      -> { where.not(claimed_at: nil) },
      class_name: "Rewarding::RewardPoolReadModel",
      foreign_key: "user_id",
      primary_key: "user_id"
  end
end
