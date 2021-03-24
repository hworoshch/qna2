class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :short_title, :body, :user_id, :created_at, :updated_at
  has_many :answers
  belongs_to :user

  def short_title
    object.title.truncate(15)
  end
end
