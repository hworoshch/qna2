FactoryBot.define do
  sequence(:title) { |n| "Question number #{n}" }

  factory :question do
    title
    body { "MyText" }
    user

    trait :invalid do
      title { nil }
    end
  end
end
