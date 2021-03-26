class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :body, :best, :created_at, :updated_at
  has_many :links
  has_many :comments
  has_many :files
end