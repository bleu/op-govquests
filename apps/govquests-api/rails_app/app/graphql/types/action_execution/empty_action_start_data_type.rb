module Types
  module ActionExecution
    class EmptyActionStartDataType < Types::BaseObject
      implements StartDataInterface
      description "Empty action data type for actions that do not require additional data"
    end
  end
end
