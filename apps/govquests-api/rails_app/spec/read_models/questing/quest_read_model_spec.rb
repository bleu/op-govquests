require "rails_helper"

RSpec.describe Questing::QuestReadModel, type: :model do
  # Associations
  it { should have_many(:quest_actions).order(:position).class_name("Questing::QuestActionReadModel").with_foreign_key("quest_id") }
  it { should have_many(:actions).through(:quest_actions).source(:action).class_name("ActionTracking::ActionReadModel") }

  # Validations
  it { should validate_presence_of(:quest_id) }
  it { should validate_uniqueness_of(:quest_id) }
  it { should validate_presence_of(:quest_type) }
  it { should validate_presence_of(:audience) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:rewards) }
  it { should validate_presence_of(:display_data) }
end
