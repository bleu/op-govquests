class ApplicationController < ActionController::API
  def current_user
    @current_user ||= Authentication::UserReadModel.first
  end
end
