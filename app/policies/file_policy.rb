class FilePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def destroy?
    user && (user.admin? || user.owner?(record))
  end
end
