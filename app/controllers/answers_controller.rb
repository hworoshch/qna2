class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :answers, from: :question
  expose :answer

  def new
  end

  def create
    question.answers << answer
    if answer.save
      redirect_to question, notice: 'Your answer successfully created.'
    else
      render :new
    end
  end

  def destroy
    answer.destroy if answer.user == current_user
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
