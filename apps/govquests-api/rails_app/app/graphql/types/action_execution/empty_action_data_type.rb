module Types
  module ActionExecution
    class EmptyActionDataType < Types::BaseObject
      implements Types::ActionDataInterface
      description "Empty action data type for actions that do not require additional data"
    end
  end
end
