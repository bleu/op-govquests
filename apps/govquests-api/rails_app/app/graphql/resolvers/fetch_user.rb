module Resolvers
  class FetchUser < BaseResolver
    type Types::UserType, null: true

    argument :id, ID, required: true

    def resolve(id:)
      Authentication::UserReadModel.find_by(user_id: id)
    end
  end
end
