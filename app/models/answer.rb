class Answer < ApplicationRecord
  include Votable
  include Commentable

  has_many :links, dependent: :destroy, as: :linkable
  has_one :award, dependent: :destroy
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      update!(award: question.award) if question.award
    end
  end
end
