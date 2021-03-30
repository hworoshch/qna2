class Search
  include ActiveModel::Validations

  INDICES = %w[answer question user comment].freeze

  attr_accessor :q, :indices

  validates :q, presence: true
  validate :validate_indices

  def initialize(attr = {})
    @q = attr[:q]
    @indices = attr[:indices] || []
  end

  def self.find(params)
    search = new(params)
    search.validate
    search
  end

  def results
    return [] if invalid?
    ThinkingSphinx.search(ThinkingSphinx::Query.escape(q), indices: indices)
  end

  private

  def validate_indices
    errors.add(:indices) unless (indices - INDICES).empty?
  end
end
