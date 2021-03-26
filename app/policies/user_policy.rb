class UserPolicy < Struct.new(:user, :profile)
  def me?
    user || user.admin?
  end

  def index?
    user || user.admin?
  end
end