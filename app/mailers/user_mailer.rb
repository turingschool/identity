class UserMailer < ActionMailer::Base
  default from: "contact@turing.io"

  def welcome_email(user)
    @user = user

    mail(
      to: @user.email,
      subject: 'Welcome to your Turing Application'
      )
  end
end