class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!

  expose :answers, -> { question.answers.sort_by_best }
  expose :answer, scope: -> { Answer.with_attached_files }

  def create
    question.answers << answer
    answer.user = current_user
    answer.save
  end

  def update
    answer.update(answer_params) if current_user.owner?(answer)
  end

  def destroy
    answer.destroy if current_user.owner?(answer)
  end

  def best
    answer.best! if current_user.owner?(question)
  end

  private

  helper_method :question

  def question
    Question.find_by(id: params[:question_id]) || answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :_destroy, :id])
  end
end
