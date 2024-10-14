module Types
  class ReadDocumentCompletionDataType < Types::BaseObject
    implements Types::CompletionDataInterface
    description "Completion data for Read Document action"

    def action_type
      "read_document"
    end
  end
end
