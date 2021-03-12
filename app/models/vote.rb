class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, touch: true

  validates :value, inclusion: { in: [-1, 1], message: "You can not vote twice" }
  validate :author_cannot_vote

  def self.up(user, votable)
    vote = Vote.find_or_initialize_by(user: user, votable: votable)
    vote.value += 1
    destroy_if_revote(vote)
  end

  def self.down(user, votable)
    vote = Vote.find_or_initialize_by(user: user, votable: votable)
    vote.value -= 1
    destroy_if_revote(vote)
  end

  def self.destroy_if_revote(vote)
    return vote unless vote.value.zero?
    vote.destroy
    nil
  end

  private_class_method :destroy_if_revote

  private

  def author_cannot_vote
    errors.add(:user, "Author can not vote!") if user&.owner?(votable)
  end
end
