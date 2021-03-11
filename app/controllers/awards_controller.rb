class AwardsController < ApplicationController
  expose :awards, -> { current_user.awards }

  def index
    # @awards = current_user.awards
  end
end
