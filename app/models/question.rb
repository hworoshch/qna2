class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  # belongs_to :best_answer, class_name: 'Answer'

  validates :title, :body, presence: true
end
