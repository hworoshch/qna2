require 'rails_helper'

RSpec.describe CommentPolicy, type: :policy do
  subject { described_class.new(user, commentable) }

  let(:commentable) { create(:question, user: create(:user)) }
  let(:comment) { create(:comment, user: user, commentable: commentable) }

  context 'admin user' do
    let(:user) { create(:user, admin: true) }

    it { is_expected.to permit_action(:create) }
  end

  context 'authenticated user' do
    let(:user) { create(:user) }

    it { is_expected.to permit_action(:create) }
  end

  context 'unauthenticated user' do
    let(:user) { nil }

    it { is_expected.to forbid_action(:create) }
  end
end
