class Api::V1::QuestionsController < Api::V1::BaseController
  expose :questions, -> { Question.all }

  def index
    render json: questions
  end
end