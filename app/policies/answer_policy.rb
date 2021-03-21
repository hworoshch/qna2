class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
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

  def best?
    user && (user.admin? || user.owner?(record.question))
  end
end
