class AnswersMailer < ApplicationMailer
  def send_answers(subscription)
    @subscription = subscription
    mail to: subscription.user.email
  end
end
