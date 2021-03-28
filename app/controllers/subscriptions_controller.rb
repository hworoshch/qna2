class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  expose :subscription, build_params: ->{ { question_id: question.id, user_id: current_user&.id } }

  def create
    authorize subscription
    subscription.save
  end

  def destroy
    authorize subscription
    subscription.destroy
  end

  private

  helper_method :question

  def question
    Question.find_by(id: params[:question_id]) || subscription.question
  end
end
