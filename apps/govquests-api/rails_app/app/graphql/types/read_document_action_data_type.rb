module Types
  class ReadDocumentActionDataType < Types::BaseObject
    implements Types::ActionDataInterface
    description "Action data for Read Document action"

    field :document_url, String, null: false

    def action_type
      "read_document"
    end
  end
end
