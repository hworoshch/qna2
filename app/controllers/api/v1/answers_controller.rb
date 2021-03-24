class Api::V1::AnswersController < Api::V1::BaseController
  skip_after_action :verify_authorized, only: [:index, :show]

  expose :answers, -> { question.answers.sort_by_best }
  expose :answer, scope: -> { Answer.with_attached_files }

  def index
    render json: answers, each_serializer: AnswersSerializer
  end

  def show
    render json: answer
  end

  def create
    authorize answer
    question.answers << answer
    answer.user = current_resource_owner
    answer.save ? head(201) : head(422)
  end

  def update
    authorize answer
    answer.update(answer_params) ? head(:ok) : head(422)
  end

  def destroy
    authorize answer
    answer.destroy
  end

  private

  def question
    Question.find_by(id: params[:question_id]) || answer.question
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end