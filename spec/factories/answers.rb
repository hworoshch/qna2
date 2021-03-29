FactoryBot.define do

  factory :answer do
    sequence(:body) { |n| "Answer sample #{n}" }
    question
    user
    
    trait :invalid do
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
