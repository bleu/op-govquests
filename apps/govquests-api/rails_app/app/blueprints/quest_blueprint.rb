class QuestBlueprint < Blueprinter::Base
  identifier :quest_id

  fields :quest_type, :audience, :status, :rewards, :display_data
  field :id do |quest|
    quest.quest_id
  end
  field :title do |quest|
    quest.display_data["title"]
  end
  field :intro do |quest|
    quest.display_data["intro"]
  end
  association :actions, blueprint: ActionBlueprint do |quest|
    quest.actions.order(:position)
  end
end
