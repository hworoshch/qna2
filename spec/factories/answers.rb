FactoryBot.define do
  sequence(:body) { |n| "Answer sample #{n}" }

  factory :answer do
    body
    question

    trait :invalid do
      body { nil }
    end
  end
end
