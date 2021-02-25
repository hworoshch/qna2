require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'owner?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:others_answer) { create(:answer, question: question, user: create(:user)) }
    it { expect(user).to be_owner(question) }
    it { expect(user).to_not be_owner(others_answer) }
  end
end
