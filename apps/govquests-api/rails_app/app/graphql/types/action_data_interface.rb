module Types
  module ActionDataInterface
    include Types::BaseInterface
    description "An interface for different action data types"

    field :action_type, String, null: false, description: "Type of the action"

    orphan_types Types::ReadDocumentActionDataType,
      Types::ActionExecution::EmptyActionDataType

    def self.resolve_type(object, _context)
      action_type = object["action_type"]

      case action_type
      when "read_document"
        Types::ReadDocumentActionDataType
      else
        Types::ActionExecution::EmptyActionDataType
      end
    end
  end
end
