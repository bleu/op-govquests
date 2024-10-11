module Mutations
  class SignOut < BaseMutation
    field :success, Boolean, null: false

    def resolve
      if context[:current_user]

        context[:session][:user_id] = nil

      end
      {success: true}
    end
  end
end
