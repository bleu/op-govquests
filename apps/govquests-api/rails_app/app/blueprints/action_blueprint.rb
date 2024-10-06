class ActionBlueprint < Blueprinter::Base
  identifier :action_id
  fields :action_type, :action_data, :display_data
  field :id do |action|
    action.action_id
  end
end
