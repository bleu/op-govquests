class QuestsController < ApplicationController
  def index
    quests = Questing::Queries::AllQuests.call
    render json: QuestBlueprint.render(quests)
  end

  def show
    quest = Questing::Queries::FindQuest.call(params[:id])
    if quest
      render json: QuestBlueprint.render(quest)
    else
      render json: {error: "Quest not found"}, status: :not_found
    end
  end
end
