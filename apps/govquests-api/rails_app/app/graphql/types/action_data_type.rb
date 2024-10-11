module Types
  class ActionDataType < Types::BaseObject
    field :document_url, String, null: true
    field :action_type, String, null: true
  end
end
