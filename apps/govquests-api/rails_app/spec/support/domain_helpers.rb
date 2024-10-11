module DomainHelpers
  def create_user(email: nil, user_type: "non_delegate", address: "0x123", chain_id: 1, user_id: nil)
    user_id = Authentication.generate_user_id(address, chain_id) if user_id.nil?
    command = Authentication::RegisterUser.new(
      user_id: user_id,
      email: email,
      user_type: user_type,
      address: address,
      chain_id: chain_id
    )
    command_bus.call(command)
    user_id
  end

  def create_quest(title:, quest_type: "Standard", audience: "AllUsers", rewards: [], quest_id: nil)
    quest_id = SecureRandom.uuid if quest_id.nil?
    display_data = {"title" => title}

    command_bus.call(Questing::CreateQuest.new(
      quest_id: quest_id,
      display_data: display_data,
      quest_type: quest_type,
      audience: audience,
      rewards: rewards
    ))

    quest_id
  end

  def create_quest_with_actions(title:, quest_type: "Standard", audience: "AllUsers", rewards: [], actions: [], quest_id: nil)
    quest_id = create_quest(title: title, quest_type: quest_type, audience: audience, rewards: rewards, quest_id: quest_id)

    action_ids = []
    actions.each_with_index do |action_attrs, index|
      action_id = create_action(**action_attrs)
      action_ids << action_id
    end

    associate_actions_with_quest(quest_id: quest_id, action_ids: action_ids)

    [quest_id, action_ids]
  end

  def associate_action_with_quest(quest_id:, action_id:, position:)
    command_bus.call(Questing::AssociateActionWithQuest.new(
      quest_id: quest_id,
      action_id: action_id,
      position: position
    ))
  end

  def associate_actions_with_quest(quest_id:, action_ids:)
    action_ids.each_with_index do |action_id, index|
      associate_action_with_quest(quest_id: quest_id, action_id: action_id, position: index)
    end
  end

  def create_action(action_type:, action_data: {}, display_data: {}, action_id: nil)
    action_id = SecureRandom.uuid if action_id.nil?
    command_bus.call(ActionTracking::CreateAction.new(
      action_id: action_id,
      action_type: action_type,
      action_data: action_data,
      display_data: display_data
    ))
    action_id
  end

  def start_user_quest(user_id:, quest_id:)
    user_quest_id = Questing.generate_user_quest_id(quest_id, user_id)
    command_bus.call(Questing::StartUserQuest.new(
      user_quest_id: user_quest_id,
      quest_id: quest_id,
      user_id: user_id
    ))
    user_quest_id
  end

  def start_action_execution(user_id:, action_id:, quest_id: nil, start_data: {})
    execution_id = ActionTracking.generate_execution_id(quest_id, action_id, user_id)
    command_bus.call(ActionTracking::StartActionExecution.new(
      execution_id: execution_id,
      quest_id: quest_id,
      action_id: action_id,
      user_id: user_id,
      start_data: start_data
    ))
    execution_id
  end

  def complete_action_execution(execution_id:, nonce:, completion_data: {})
    command_bus.call(ActionTracking::CompleteActionExecution.new(
      execution_id: execution_id,
      nonce: nonce,
      completion_data: completion_data
    ))
  end

  private

  def command_bus
    Rails.configuration.command_bus
  end
end
