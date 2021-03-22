FactoryBot.define do
  sequence(:body) { |n| "Answer sample #{n}" }

  factory :answer do
    body
    question
    user
    
    trait :invalid do
      body { nil }
    end
  end
end
