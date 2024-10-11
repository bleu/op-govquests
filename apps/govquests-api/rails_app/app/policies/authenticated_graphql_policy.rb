class AuthenticatedGraphqlPolicy < ApplicationPolicy
  def show?
    user.present?
  end
end
