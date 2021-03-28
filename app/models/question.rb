class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy
  has_one :award, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  scope :latest, ->(since = 1.day.ago) { where(created_at: since..) }

  accepts_nested_attributes_for :links, :award, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create :create_owner_subscription

  private

  def create_owner_subscription
    subscriptions.create!(user: user)
  end
end
