require 'rails_helper'

RSpec.describe AnswersSubscriptionJob, type: :job do
  let(:service) { double('AnswersSubscription') }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  before do
    allow(AnswersSubscription).to receive(:new).and_return(service)
  end

  it 'calls AnswersSubscription#send_subscription' do
    expect(service).to receive(:send_subscription)
    AnswersSubscriptionJob.perform_now(answer)
  end
end
