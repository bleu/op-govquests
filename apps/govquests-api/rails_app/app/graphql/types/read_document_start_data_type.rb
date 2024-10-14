module Types
  class ReadDocumentStartDataType < Types::BaseObject
    implements Types::StartDataInterface
    description "Start data for Read Document action"

    def action_type
      "read_document"
    end
  end
end
