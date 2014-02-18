class UserMailer < ActionMailer::Base
  default from: "\"Turing School\" <contact@turing.io>"

  def welcome(user)
    mail(
      to: user.email,
      subject: 'Welcome to your Turing Application'
      )
  end

  def quiz(user)
    mail(
      to: user.email,
      subject: 'Prepare for the Logic Quiz'
      )
  end

  def final(user)
    mail(
      to: user.email,
      subject: 'Your Turing Application is complete'
      )
  end
end