class AwardsController < ApplicationController
  expose :awards, -> { current_user.awards }

  def index; end
end
