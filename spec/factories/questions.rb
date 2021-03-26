FactoryBot.define do
  sequence(:title) { |n| "Question number #{n}" }

  factory :question do
    title
    body { "MyText" }
    user

    trait :invalid do
      title { nil }
      body { nil }
    end

    trait :attached_files do
      files { [
        Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/rails_helper.rb'))),
        Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/spec_helper.rb')))
      ] }
    end
  end
end
