class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :body, :best, :created_at, :updated_at
  belongs_to :user
end
