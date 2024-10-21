module Types
  module ActionExecution
    class EmptyActionCompletionDataType < Types::BaseObject
      implements CompletionDataInterface
      description "Empty action data type for actions that do not require additional data"
    end
  end
end
