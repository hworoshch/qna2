require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:votable).touch(true) }
  it { should belong_to :user }

  it { should validate_inclusion_of(:value).in_array([-1, 1]).with_message("You can not vote twice") }

  describe '#up' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: create(:user)) }
    let(:votable) { create(:answer, question: question, user: create(:user)) }

    it { expect(described_class.up(user, votable)).to be_an_instance_of(Vote) }

    it 'nil if revote' do
      create(:vote, user: user, votable: votable, value: -1)
      expect(described_class.up(user, votable)).to be_nil
    end

    context 'someone elses votable' do
      it { expect { described_class.up(user, votable).save }.to change(votable, :rating).by(1) }

      it 'already have vote' do
        create(:vote, user: create(:user), votable: votable, value: 1)
        expect { described_class.up(user, votable).save }.to change(votable, :rating).by(1)
      end
    end

    context 'own votable' do
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }
      let(:votable) { create(:answer, question: question, user: user) }
      it { expect { described_class.up(user, votable).save }.to_not change(votable, :rating) }
      it 'have error message' do
        vote = described_class.up(user, votable)
        vote.valid?
        expect(vote.errors[:user]).to include("Author can not vote!")
      end
    end
  end

  describe '#down' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: create(:user)) }
    let(:votable) { create(:answer, question: question, user: create(:user)) }

    it { expect(described_class.down(user, votable)).to be_an_instance_of(Vote) }

    it 'nil if revote' do
      create(:vote, user: user, votable: votable, value: 1)
      expect(described_class.down(user, votable)).to be_nil
    end

    context 'others votable' do
      it do
        expect { described_class.down(user, votable).save }.to change(votable, :rating).by(-1)
      end

      it 'already have vote' do
        create(:vote, user: create(:user), votable: votable, value: 1)
        expect { described_class.down(user, votable).save }.to change(votable, :rating).by(-1)
      end
    end

    context 'own votable' do
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }
      let(:votable) { create(:answer, question: question, user: user) }
      it { expect { described_class.down(user, votable).save }.to_not change(votable, :rating) }
      it 'have error message' do
        vote = described_class.down(user, votable)
        vote.valid?
        expect(vote.errors[:user]).to include("Author can not vote!")
      end
    end
  end
end
