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
  def self.create_quest_with_rewards(quest_data)
    quest_id = SecureRandom.uuid

    Rails.configuration.command_bus.call(
      Questing::CreateQuest.new(
        quest_id: quest_id,
        display_data: quest_data[:display_data],
        audience: quest_data[:audience]
      )
    )

    quest_data[:rewards].each do |reward|
      pool_id = SecureRandom.uuid
      Rails.configuration.command_bus.call(
        Rewarding::CreateRewardPool.new(
          pool_id: pool_id,
          quest_id: quest_id,
          reward_definition: reward,
          initial_inventory: (reward["type"] == "Token") ? 1000 : nil
        )
      )

      Rails.configuration.command_bus.call(
        Questing::AssociateRewardPool.new(
          quest_id: quest_id,
          pool_id: pool_id,
          reward_definition: reward
        )
      )
    end

    quest_id
  end

  def self.associate_action_with_quest(quest_id, action_id, position)
    Rails.configuration.command_bus.call(
      Questing::AssociateActionWithQuest.new(
        quest_id: quest_id,
        action_id: action_id,
        position: position
      )
    )
  end
end

module QuestData
  DISCOURSE_VERIFICATION_ACTION = {
    action_type: "discourse_verification",
    display_data: {
      title: "Verify Discourse Account",
      description: "To verify you must authorize GovQuest's access to your Discourse Account. After your authorization, you'll be provided with the API Key that must be entered bellow."
    },
    action_data: {
      action_type: "discourse_verification",
      discourse_url: "https://gov.optimism.io"
    }
  }
  UNLOCK_PROFILE_ACTIONS = [
    {
      action_type: "send_email",
      display_data: {
        title: "Inform your e-mail (optional)",
        description: "Get notified about your achievements, new quests and more. We won't spam you :)"
      },
      action_data: {
        action_type: "send_email"
      }
    },
    {
      action_type: "wallet_verification",
      display_data: {
        title: "Connect your wallet",
        description: "Track your progress, earn rewards, and get recognized for your contributions."
      },
      action_data: {
        action_type: "wallet_verification"
      }
    }
  ]

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
      title: "Verify ENS",
      description: "Claim your unique ENS name!"
    },
    action_data: {
      action_type: "ens"
    }
  }

  VERIFY_POSITION_ACTION = {
    action_type: "verify_position",
    display_data: {
      title: "Verify your position",
      description: "Click to verify your status as a Top 100 Delegate."
    },
    action_data: {
      action_type: "verify_position",
      should_be_higher_than: 100
    }
  }

  QUESTS = [
    {
      display_data: {
        title: "Claim Your Identity",
        intro: "Building a strong reputation in the Optimism Collective starts with having a <strong>Ethereum Name Service (ENS)</strong>, and also a <strong>recognizable name</strong> in the Governance Forum. A unique identity helps the community remember you and <strong>connects your ideas to a trusted name.</strong> Let’s take the first step towards establishing your presence in OP governance!",
        image_url: "https://example.com/discourse-verification.jpg",
        requirements: "<span>To complete this quest, you need to have:</span> <ul><li>A <strong>ENS</strong> — if you don't have it, <a href='https://ens.domains/' target='_blank' rel='noopener noreferrer'>register your ENS here</a> and remember to <strong>choose a distinct username</strong> that represents you (like yourname.eth).</li> <li>A <strong>Discourse account</strong> on <strong>Optimism Governance Forum</strong> — if you also don't have it, <a href='https://gov.optimism.io/' target='_blank' rel='noopener noreferrer'>create your account here.</a> We recommend you to use your ENS as username so you can get easily recognizable.</li></ul>"
      },
      audience: "Delegates",
      rewards: [{type: "Points", amount: 165}],
      actions: [ENS_ACTION, DISCOURSE_VERIFICATION_ACTION]
    },
    {
      display_data: {
        title: "Unlock Your Profile",
        intro: "Connect your wallet to unlock the full experience. Track your progress, earn rewards, and get recognized for your contributions.",
        image_url: "https://example.com/governance101.jpg"
      },
      audience: "AllUsers",
      rewards: [{type: "Points", amount: 55}],
      actions: UNLOCK_PROFILE_ACTIONS
    },
    {
      display_data: {
        title: "Governance 101",
        intro: "As a Delegate, understanding Optimism's values and your responsibilities is key. This quest will provide essential resources to help you make informed decisions and contribute to Optimism's future.",
        image_url: "https://example.com/governance101.jpg"
      },
      audience: "AllUsers",
      rewards: [{type: "Points", amount: 165}],
      actions: READ_DOCUMENT_ACTIONS
    },
    {
      display_data: {
        title: "Gitcoin Score",
        intro: "Connect your Gitcoin Passport and verify your Unique Humanity Score to help strengthen our community. It's quick and easy, and you'll be contributing to a more secure ecosystem!",
        image_url: "https://example.com/advanced-governance.jpg",
        requirements: "Your Unique Humanity Score must be 20 or higher to complete this quest. Not there yet? Check some tips on how to increase your score."
      },
      audience: "Delegates",
      rewards: [{type: "Points", amount: 55}],
      actions: [GITCOIN_ACTION]
    },

    {
      display_data: {
        title: "Top 100 Delegates",
        intro: "Have you reached the Top 100 Delegates in Season 6? Let’s check your ranking and, if you’re among the top, celebrate your achievement with a reward!",
        image_url: "https://example.com/advanced-governance.jpg",
        requirements: "You need to be a delegate to do this quest! If you’re not one, start with Become Delegate Quest."
      },
      audience: "Delegates",
      rewards: [{type: "Points", amount: 165}],
      actions: [VERIFY_POSITION_ACTION]
    }
  ]
end

def create_quests_and_actions
  puts "Creating quests, actions, and reward pools..."

  QuestData::QUESTS.each do |quest_data|
    # Create quest and its reward pools
    quest_id = QuestCreation.create_quest_with_rewards(quest_data)
    puts "Created quest: #{quest_data[:display_data][:title]} (#{quest_id})"
    puts "Created reward pools for quest rewards: #{quest_data[:rewards].inspect}"

    # Create and associate actions
    quest_data[:actions].each_with_index do |action_data, index|
      action_id = ActionCreation.create_action(action_data)
      QuestCreation.associate_action_with_quest(quest_id, action_id, index + 1)
      puts "Created and associated action: #{action_data[:display_data][:title]} (#{action_id}) with quest #{quest_id} at position #{index + 1}"
    end

    puts "Completed quest: #{quest_data[:display_data][:title]} (#{quest_id}) with #{quest_data[:actions].size} actions"
    puts "---"
  end

  puts "All quests created with their actions and reward pools successfully!"
end

create_quests_and_actions
