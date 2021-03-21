require 'rails_helper'

RSpec.describe VotePolicy, type: :policy do
  subject { described_class.new(user, votable) }

  let(:votable) { create(:question, user: create(:user)) }
  let(:vote) { create(:vote, user: user, votable: votable) }

  context 'admin user' do
    let(:user) { create(:user, admin: true) }

    it { is_expected.to permit_actions([:up, :down]) }
  end

  context 'authenticated user' do
    let(:user) { create(:user) }

    it { is_expected.to permit_actions([:up, :down]) }
  end

  context 'authenticated user as owner' do
    let(:user) { votable.user }

    it { is_expected.to forbid_actions([:up, :down]) }
  end

  context 'unauthenticated user' do
    let(:user) { nil }

    it { is_expected.to forbid_actions([:up, :down]) }
  end
end
