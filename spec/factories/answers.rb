FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question_id { 1 }

    trait :invalid do
      body { nil }
    end
  end
end
