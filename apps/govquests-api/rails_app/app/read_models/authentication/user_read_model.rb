module Authentication
  class UserReadModel < ApplicationRecord
    self.table_name = "users"

    validates :address, presence: true, uniqueness: true
    validates :user_type, presence: true, inclusion: {in: %w[delegate non_delegate]}

    has_many :sessions, class_name: "Authentication::SessionReadModel", foreign_key: :user_id
  end
end
