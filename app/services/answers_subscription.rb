class AnswersSubscription
  def send_subscription(answer)
    answer.question.subscriptions.find_each do |subscription|
      AnswersMailer.send_answers(subscription).deliver_later
    end
  end
end