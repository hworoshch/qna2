class AwardPolicy < ApplicationPolicy
  def index?
    user || user.admin?
  end
end