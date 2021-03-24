class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    authorize User
    render json: current_resource_owner
  end

  def index
    authorize User
    render json: User.where.not(id: current_resource_owner.id)
  end
end