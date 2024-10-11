require "rails_helper"

RSpec.describe Rewarding::RewardReadModel, type: :model do
  # Validations
  it { should validate_presence_of(:reward_id) }
  it { should validate_uniqueness_of(:reward_id) }
  it { should validate_presence_of(:reward_type) }
  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:expiry_date) }
  it { should validate_presence_of(:delivery_status) }

  # Inclusion validation for delivery_status
  it { should validate_inclusion_of(:delivery_status).in_array(%w[Pending Issued Claimed Expired InventoryDepleted]) }

  # Additional associations or validations can be added here
end
