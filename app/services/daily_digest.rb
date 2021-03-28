class DailyDigest
  def send_digest
    User.all.each do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end
end