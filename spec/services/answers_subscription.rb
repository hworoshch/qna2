require 'rails_helper'

RSpec.describe AnswersSubscription do
  let(:users) { create_list(:user, 3) }
  let(:question) { create(:question, user: users[0]) }
  let!(:answer) { create(:answer, question: question, user: users[1]) }
  let!(:subscription) { create(:subscription, question: question, user: users[1]) }

  it 'sends answer to all subscribed users' do
    question.subscriptions.each do |subscription|
      expect(AnswersMailer).to receive(:send_answers).with(subscription).and_call_original
    end
    subject.send_subscription(answer)
  end

  it 'not sends answer to not subscribed users' do
    expect { subject.send_subscription(answer) }.to_not change(ActionMailer::Base.deliveries, :count)
  end
end