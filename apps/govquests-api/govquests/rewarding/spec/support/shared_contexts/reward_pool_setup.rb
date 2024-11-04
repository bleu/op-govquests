RSpec.shared_context "with reward pool setup", shared_context: :metadata do |reward_definition, initial_inventory: nil|
  before do
    pool.create(
      quest_id: quest_id,
      reward_definition: reward_definition,
      initial_inventory: initial_inventory
    )
  end
end
