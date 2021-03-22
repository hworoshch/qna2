class VotePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def up?
    user && (user.admin? || !user.owner?(record))
  end

  def down?
    user && (user.admin? || !user.owner?(record))
  end
end
