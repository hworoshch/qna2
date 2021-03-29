class AnswersSubscriptionJob < ApplicationJob
  queue_as :default

  def perform(answer)
    AnswersSubscription.new.send_subscription(answer)
  end
end
