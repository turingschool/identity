class UserMailer < ActionMailer::Base
  default from: "\"Turing School\" <contact@turing.io>"

  def welcome_email(user)
    mail(
      to: user.email,
      subject: 'Welcome to your Turing Application'
      )
  end

  def quiz_email(user)
    mail(
      to: user.email,
      subject: 'Prepare for the Logic Quiz'
      )
  end

  def final_email(user)
    mail(
      to: user.email,
      subject: 'Your Turing Application is complete'
      )
  end
end