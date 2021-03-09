class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
