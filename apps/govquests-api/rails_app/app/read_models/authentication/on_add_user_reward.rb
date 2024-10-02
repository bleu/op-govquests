module Authentication
  class OnAddUserReward
    def call(event)
      user_id = event.data.fetch(:user_id)
      reward_id = event.data.fetch(:reward_id)

      user = User.find_by(user_id: user_id)
      user&.update_column(:last_reward_id, reward_id)
    end
  end
end
