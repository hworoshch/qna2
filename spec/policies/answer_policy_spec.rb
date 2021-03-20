require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  subject { described_class.new(user, answer) }

  let(:answer) { create(:answer) }

  context 'admin user' do
    let(:user) { create(:user, admin: true) }

    it { is_expected.to permit_actions([:create, :update, :destroy, :best]) }
  end

  context 'authenticated user' do
    let(:user) { create(:user) }

    it { is_expected.to permit_action(:create) }
    it { is_expected.to forbid_actions([:update, :destroy, :best]) }
  end

  context 'authenticated user as owner' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer, user: user) }

    it { is_expected.to permit_actions([:update, :destroy]) }
    it { is_expected.to forbid_action(:best) }
  end

  context 'authenticated user as question owner' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question) }

    it { is_expected.to permit_action(:best) }
  end

  context 'unauthenticated user' do
    let(:user) { nil }

    it { is_expected.to forbid_actions([:create, :update, :destroy, :best]) }
  end
end
