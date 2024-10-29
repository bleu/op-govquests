module Types
  class ActionExecution::Strategies::Ens::EnsDomainType < Types::BaseObject
    field :name, String, null: false, description: "The name of the domain"
    field :owner, String, null: false, description: "The owner of the domain"
    field :wrapped_owner, String, null: true, description: "The wrapped owner of the domain"
    field :resolved_address, String, null: true, description: "The resolved address of the domain"
  end
end
