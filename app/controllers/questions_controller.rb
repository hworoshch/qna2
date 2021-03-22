class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_gon, only: [:show]
  after_action :publish_question, only: [:create]
  skip_after_action :verify_authorized, only: [:index, :show]

  include Voted

  expose :questions, -> { Question.all }
  expose :question, scope: -> { Question.with_attached_files }
  expose :answers, -> { question.answers.sort_by_best }
  expose :answer, -> { Answer.new }
  expose :comment, -> { question.comments.new }

  def index; end

  def show; end

  def new
    authorize question
    question.build_award
  end

  def create
    authorize question
    question.user = current_user
    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      question.build_award unless question.award
      render :new
    end
  end

  def update
    authorize question
    question.update(question_params)
  end

  def destroy
    authorize question
    question.destroy
    redirect_to questions_path, notice: 'Your question has been deleted.'
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: [:name, :url, :_destroy, :id],
                                     award_attributes: [:title, :image])
  end

  def publish_question
    return if question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: {
          question: question,
          current_user: current_user
        }
      )
    )
  end

  def set_gon
    gon.question_id = question.id
    gon.current_user_id = current_user&.id
  end
end
