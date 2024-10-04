class QuestsController < ApplicationController
  def index
    quests = Questing::QuestReadModel.all.map { |quest| quest_data(quest) }
    render json: quests
  end

  def show
    quest = Questing::QuestReadModel.find_by(quest_id: params[:id])
    if quest
      render json: quest_data(quest)
    else
      render json: { error: "Quest not found" }, status: :not_found
    end
  end

  private

  def quest_data(quest)
    {
      id: quest.quest_id,
      title: quest.title,
      intro: quest.intro,
      quest_type: quest.quest_type,
      audience: quest.audience,
      status: quest.status,
      # TODO: rewards is a map, should be an array
      rewards: [ quest.rewards ],
      # add img_url
      actions: fetch_quest_actions(quest.quest_id)
    }
  end

  def fetch_quest_actions(quest_id)
    Questing::QuestActionReadModel.where(quest_id: quest_id)
      .order(:position)
      .includes(:action)
      .map do |quest_action|
      {
        id: quest_action.action.action_id,
        content: quest_action.action.content,
        action_type: quest_action.action.action_type,
        completion_criteria: quest_action.action.completion_criteria,
        position: quest_action.position
      }
    end
  end
end
