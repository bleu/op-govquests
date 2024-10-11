# spec/models/authentication/user_read_model_spec.rb
require "rails_helper"

RSpec.describe Authentication::UserReadModel, type: :model do
  # Associations
  it { should have_many(:sessions).class_name("Authentication::SessionReadModel").with_foreign_key("user_id") }

  # Validations
  it { should validate_presence_of(:address) }
  it { should validate_uniqueness_of(:address) }
  it { should validate_presence_of(:user_type) }
  it { should validate_inclusion_of(:user_type).in_array(%w[delegate non_delegate]) }
end
