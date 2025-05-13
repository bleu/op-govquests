module Authentication
  class OnUserTypeUpdated
    def call(event)
      user_id = event.data[:user_id]
      user_type = event.data[:user_type]

      user = Authentication::UserReadModel.find_by(user_id: user_id)
      user.update!(
        user_type: user_type
      )
    end
  end
end
