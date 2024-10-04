# app/controllers/quests_controller.rb
class QuestsController < ApplicationController
  def index
    quests = Questing::QuestReadModel.all.map do |quest|
      {
        id: quest.quest_id,
        title: quest.title,
        intro: quest.intro,
        image_url: quest.image_url,
        quest_type: quest.quest_type,
        audience: quest.audience,
        status: quest.status,
        rewards: [quest.rewards],
        actions: quest.quest_actions.map do |quest_action|
          action = quest_action.action

          {
            id: action.action_id,
            content: action.content,
            action_type: action.action_type
          }
        end
      }
    end

    render json: quests
  end

  def show
    quest = Questing::QuestReadModel.find_by(quest_id: params[:id])

    if quest
      render json: {
        id: quest.quest_id,
        title: quest.title,
        intro: quest.intro,
        image_url: quest.image_url,
        quest_type: quest.quest_type,
        audience: quest.audience,
        status: quest.status,
        rewards: [quest.rewards],
        actions: quest.quest_actions.map do |quest_action|
          action = quest_action.action

          {
            id: action.action_id,
            content: action.content,
            action_type: action.action_type
          }
        end
      }
    else
      render json: {error: "Quest not found"}, status: :not_found
    end
  end
end
