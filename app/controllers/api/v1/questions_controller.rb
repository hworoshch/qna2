class Api::V1::QuestionsController < Api::V1::BaseController
  expose :questions, -> { Question.all }
  expose :question, scope: -> { Question.with_attached_files }

  def index
    render json: questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: question
  end

  def create
    question = current_resource_owner.questions.new(question_params)
    question.save ? head(201) : head(422)
  end

  def update
    question.update(question_params) ? head(:ok) : head(422)
  end

  def destroy
    question.destroy
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end