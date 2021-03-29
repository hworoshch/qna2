class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.latest
    mail to: user.email
  end
end
