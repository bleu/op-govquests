require "securerandom"

def create_action(action_data)
  action_id = SecureRandom.uuid
  command = ActionTracking::CreateAction.new(
    action_id: action_id,
    action_type: action_data[:action_type],
    action_data: action_data[:action_data],
    display_data: action_data[:display_data]
  )
  Rails.configuration.command_bus.call(command)
  action_id
end

actions_data = [
  {
    action_type: "read_document",
    display_data: {content: "Read the Code of Conduct"},
    action_data: {

      document_url: "https://example.com/code-of-conduct"
    }
  },
  {
    action_type: "gitcoin_score",
    display_data: {content: "Complete Gitcoin Passport verification"},
    action_data: {

      min_score: 20
    }
  }
]

puts "Creating actions..."
action_ids = actions_data.map do |action_data|
  action_id = create_action(action_data)
  puts "Created action: #{action_data[:action_data][:content]} (#{action_id})"
  action_id
end

puts "Actions created successfully!"

quests_data = [
  {
    display_data: {
      title: "Governance 101",
      intro: "Understand the Optimism Values and your role in governance.",
      image_url: "https://example.com/governance101.jpg"
    },
    quest_type: "Onboarding",
    audience: "AllUsers",
    rewards: [{type: "Points", amount: 50}],
    actions: action_ids.take(4) # Use the first 4 actions
  },
  {
    display_data: {
      title: "Advanced Governance Practices",
      intro: "Dive deeper into governance processes and decision-making.",
      image_url: "https://example.com/advanced-governance.jpg"
    },
    quest_type: "Governance",
    audience: "Delegates",
    rewards: [{type: "Points", amount: 100}],
    actions: action_ids.drop(4) # Use the last 4 actions
  }
]

def create_quest(quest_data)
  quest_id = SecureRandom.uuid
  command = Questing::CreateQuest.new(
    quest_id: quest_id,
    display_data: quest_data[:display_data],
    quest_type: quest_data[:quest_type],
    audience: quest_data[:audience],
    rewards: quest_data[:rewards]
  )
  Rails.configuration.command_bus.call(command)
  quest_id
end

def associate_action_with_quest(quest_id, action_id, position)
  command = Questing::AssociateActionWithQuest.new(
    quest_id: quest_id,
    action_id: action_id,
    position: position
  )
  Rails.configuration.command_bus.call(command)
end

puts "Creating quests and associating actions..."
quests_data.each do |quest_data|
  quest_id = create_quest(quest_data)

  quest_data[:actions].each_with_index do |action_id, index|
    associate_action_with_quest(quest_id, action_id, index + 1)
  end

  puts "Created quest: #{quest_data[:display_data][:title]} (#{quest_id}) with #{quest_data[:actions].size} actions"
end

puts "Quests created and actions associated successfully!"

Rails.configuration.command_bus.call(Authentication::RegisterUser.new(
  user_id: SecureRandom.uuid,
  email: "jose@bleu.studio",
  user_type: "non_delegate",
  wallet_address: "0x26394373F96950025DA55b07809c976a4768c995",
  chain_id: 10
))
