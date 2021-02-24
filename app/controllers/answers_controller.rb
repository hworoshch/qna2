class AnswersController < ApplicationController

  def new
  end

  def create
    @answer = question.answers.new(answer_params)
    if @answer.save
      redirect_to question, notice: 'Your answer successfully created.'
    else
      render :new
    end
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
