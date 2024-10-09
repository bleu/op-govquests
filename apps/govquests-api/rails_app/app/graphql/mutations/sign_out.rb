module Mutations
  class SignOut < BaseMutation
    field :success, Boolean, null: false

    def resolve
      if context[:current_user]

        context[:session][:user_id] = nil

        {success: true}
      else
        {success: false}
      end
    end
  end
end
