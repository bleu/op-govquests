require "securerandom"

module ActionCreation
  def self.create_action(action_data)
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
end

module QuestCreation
  def self.create_quest(quest_data)
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

  def self.associate_action_with_quest(quest_id, action_id, position)
    command = Questing::AssociateActionWithQuest.new(
      quest_id: quest_id,
      action_id: action_id,
      position: position
    )
    Rails.configuration.command_bus.call(command)
  end
end

module QuestData
  DISCOURSE_VERIFICATION_ACTION = {
    action_type: "discourse_verification",
    display_data: {
      title: "Verify Discourse Account",
      description: "Connect and verify your Discourse account to participate in governance discussions."
    },
    action_data: {
      action_type: "discourse_verification",
      discourse_url: "https://gov.optimism.io"
    }
  }

  READ_DOCUMENT_ACTIONS = [
    {
      action_type: "read_document",
      display_data: {
        title: "Code of conduct",
        description: ""
      },
      action_data: {
        action_type: "read_document",
        document_url: "https://gov.optimism.io/t/code-of-conduct/5751"
      }
    },
    {
      action_type: "read_document",
      display_data: {
        title: "Optimistic Vision",
        description: ""
      },
      action_data: {
        action_type: "read_document",
        document_url: "https://www.optimism.io/vision"
      }
    },
    {
      action_type: "read_document",
      display_data: {
        title: "Working Constitution",
        description: ""
      },
      action_data: {
        action_type: "read_document",
        document_url: "https://gov.optimism.io/t/working-constitution-of-the-optimism-collective/55"
      }
    },
    {
      action_type: "read_document",
      display_data: {
        title: "Delegate Expectations",
        description: ""
      },
      action_data: {
        action_type: "read_document",
        document_url: "https://community.optimism.io/token-house/delegate-expectations"
      }
    }
  ]

  GITCOIN_ACTION = {
    action_type: "gitcoin_score",
    display_data: {
      title: "Connect your Gitcoin Passport",
      description: "Let's be sure you're human!"
    },
    action_data: {
      action_type: "gitcoin_score",
      min_score: 20
    }
  }

  ENS_ACTION = {
    action_type: "ens",
    display_data: {
      title: "Set your ENS name",
      description: "Claim your unique ENS name!"
    },
    action_data: {
      action_type: "ens"
    }
  }

  QUESTS = [
    {
      display_data: {
        title: "Discourse Verification",
        intro: "Verify your Discourse account to actively participate in Optimism's governance discussions. This quest will guide you through the process of connecting your Discourse account.",
        image_url: "https://example.com/discourse-verification.jpg",
        requirements: "You must have a Discourse account on the Optimism governance forum to complete this quest. If you don't have one, you'll be guided to create one."
      },
      quest_type: "Governance",
      audience: "Delegates",
      rewards: [{type: "Points", amount: 150}],
      actions: [DISCOURSE_VERIFICATION_ACTION]
    },
    {
      display_data: {
        title: "Governance 101",
        intro: "As a Delegate, understanding Optimism's values and your responsibilities is key. This quest will provide essential resources to help you make informed decisions and contribute to Optimism's future.",
        image_url: "https://example.com/governance101.jpg"
      },
      quest_type: "Onboarding",
      audience: "AllUsers",
      rewards: [{type: "Points", amount: 20}],
      actions: READ_DOCUMENT_ACTIONS
    },
    {
      display_data: {
        title: "Gitcoin Score",
        intro: "Connect your Gitcoin Passport and verify your Unique Humanity Score to help strengthen our community. It's quick and easy, and you'll be contributing to a more secure ecosystem!",
        image_url: "https://example.com/advanced-governance.jpg",
        requirements: "Your Unique Humanity Score must be 20 or higher to complete this quest. Not there yet? Check some tips on how to increase your score."
      },
      quest_type: "Governance",
      audience: "Delegates",
      rewards: [{type: "Points", amount: 100}],
      actions: [GITCOIN_ACTION]
    },
    {
      display_data: {
        title: "ENS Name",
        intro: "Claim your unique ENS name and make it easier for others to find you. This quest will guide you through the process of setting up your ENS name.",
        image_url: "https://example.com/ens-name.jpg",
        requirements: "You must have an ENS name to complete this quest. Not sure how to get one? Check some tips on how to set up your ENS name."
      },
      quest_type: "Governance",
      audience: "Delegates",
      rewards: [{type: "Points", amount: 100}],
      actions: [ENS_ACTION]
    }
  ]
end

def create_quests_and_actions
  puts "Creating quests and actions..."
  QuestData::QUESTS.each do |quest_data|
    quest_id = QuestCreation.create_quest(quest_data)
    puts "Created quest: #{quest_data[:display_data][:title]} (#{quest_id})"

    quest_data[:actions].each_with_index do |action_data, index|
      action_id = ActionCreation.create_action(action_data)
      QuestCreation.associate_action_with_quest(quest_id, action_id, index + 1)
      puts "Created and associated action: #{action_data[:display_data][:title]} (#{action_id}) with quest #{quest_id} at position #{index + 1}"
    end

    puts "Completed quest: #{quest_data[:display_data][:title]} (#{quest_id}) with #{quest_data[:actions].size} actions"
    puts "---"
  end

  puts "All quests created and actions associated successfully!"
end

create_quests_and_actions
