require 'rails_helper'

RSpec.describe FilePolicy, type: :policy do
  subject { described_class.new(user, question) }

  let(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
  let(:question) { create(:question, user: create(:user), files: [file]) }

  context 'admin user' do
    let(:user) { create(:user, admin: true) }

    it { is_expected.to permit_action(:destroy) }
  end

  context 'authenticated user' do
    let(:user) { create(:user) }

    it { is_expected.to forbid_action(:destroy) }
  end

  context 'authenticated user as owner' do
    let(:user) { question.user }

    it { is_expected.to permit_action(:destroy) }
  end

  context 'unauthenticated user' do
    let(:user) { nil }

    it { is_expected.to forbid_action(:destroy) }
  end
end
