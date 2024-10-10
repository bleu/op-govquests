class ApplicationController < ActionController::API
  def current_user
    @current_user ||= Authentication::UserReadModel.find_by(user_id: session[:user_id])
  end
end
