require 'rails_helper'

RSpec.describe QuestionPolicy, type: :policy do
  subject { described_class.new(user, question) }

  let(:question) { create(:question) }

  context 'admin user' do
    let(:user) { create(:user, admin: true) }

    it { is_expected.to permit_actions([:index, :show, :new, :create, :update, :destroy]) }
  end

  context 'authenticated user' do
    let(:user) { create(:user) }

    it { is_expected.to permit_actions([:index, :show, :new, :create]) }
    it { is_expected.to forbid_actions([:update, :destroy]) }
  end

  context 'authenticated user as owner' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it { is_expected.to permit_actions([:update, :destroy]) }
  end

  context 'unauthenticated user' do
    let(:user) { nil }

    it { is_expected.to permit_actions([:index, :show]) }
    it { is_expected.to forbid_actions([:new, :create, :update, :destroy]) }
  end
end
