class AnswersController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_answer, only: [:create]

  include Voted

  expose :answers, -> { question.answers.sort_by_best }
  expose :answer, scope: -> { Answer.with_attached_files }
  expose :comment, -> { answer.comments.new }

  def create
    authorize answer
    question.answers << answer
    answer.user = current_user
    answer.save
  end

  def update
    authorize answer
    answer.update(answer_params)
  end

  def destroy
    authorize answer
    answer.destroy
  end

  def best
    authorize answer
    answer.best!
  end

  private

  helper_method :question

  def question
    Question.find_by(id: params[:question_id]) || answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :_destroy, :id])
  end

  def publish_answer
    return if answer.errors.any?
    ActionCable.server.broadcast("question_#{question.id}_answers",
                                 answer: answer)
  end
end
