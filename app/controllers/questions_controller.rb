class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  expose :questions, -> { Question.all }
  expose :question
  expose :answers, from: :question
  expose :answer, -> { Answer.new }

  def index
  end

  def show
  end

  def new
  end

  def create
    question.user = current_user
    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if question.update(question_params)
      redirect_to question
    else
      render :edit
    end
  end

  def destroy
    question.destroy if current_user.owner?(question)
    redirect_to questions_path, notice: 'Your question has been deleted.'
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
