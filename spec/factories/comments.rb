FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "Comment sample #{n}" }
    user
  end
end
