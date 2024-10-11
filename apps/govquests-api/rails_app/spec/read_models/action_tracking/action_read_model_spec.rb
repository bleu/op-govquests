require "rails_helper"

RSpec.describe ActionTracking::ActionReadModel, type: :model do
  # Associations
  it { should have_many(:action_executions).class_name("ActionTracking::ActionExecutionReadModel").with_foreign_key("action_id") }

  # Validations
  it { should validate_presence_of(:action_type) }
  it { should validate_presence_of(:action_data) }
  it { should validate_presence_of(:display_data) }
end
