class ApplicationController < ActionController::Base
  include Pundit

  # after_action :verify_authorized,  except: :index
  # after_action :verify_policy_scoped, only: :index
  #
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  # def user_not_authorized
  #   flash[:error] = "You are not authorized to perform this action."
  #   redirect_to request.headers["Referer"] || root_path
  # end
end
