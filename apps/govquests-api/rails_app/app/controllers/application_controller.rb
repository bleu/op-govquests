class ApplicationController < ActionController::API
  include ActionPolicy::Controller

  authorize :user, through: :current_user

  def current_user
    @current_user ||= Authentication::UserReadModel.find_by(user_id: session[:user_id])
  end
end
