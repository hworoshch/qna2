class QuestionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def new?
    user
  end

  def create?
    user
  end

  def update?
    user && (user.admin? || user.owner?(record))
  end

  def destroy?
    user && (user.admin? || user.owner?(record))
  end
end
