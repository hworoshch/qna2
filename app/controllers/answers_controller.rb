class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :answers, -> { question.answers.sort_by_best }
  expose :answer

  def create
    question.answers << answer
    answer.user = current_user
    answer.save
  end

  def update
    answer.update(answer_params)
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
    params.require(:answer).permit(:body)
  end
end
