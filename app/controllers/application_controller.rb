class ApplicationController < ActionController::Base
  include Pundit
  after_action :verify_authorized, unless: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    @error = "You are not authorized to perform this action."
    respond_to do |format|
      format.html do
        flash[:error] = @error
        redirect_to request.headers["Referer"] || root_path
      end
      format.json { render json: [@error], status: :forbidden }
      format.js { render json: [@error], status: :forbidden }
    end
  end
end
