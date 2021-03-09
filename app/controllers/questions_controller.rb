class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  expose :questions, -> { Question.all }
  expose :question, scope: -> { Question.with_attached_files }
  expose :answers, -> { question.answers.sort_by_best }
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

  def update
    question.update(question_params) if current_user.owner?(question)
  end

  def destroy
    question.destroy if current_user.owner?(question)
    redirect_to questions_path, notice: 'Your question has been deleted.'
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
