class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t(".mail_subject")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t(".mail_subject")
  end
end
