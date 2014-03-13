class UserMailer < ActionMailer::Base
  default from: "\"Turing School\" <contact@turing.io>"

  def welcome(user)
    subject = 'Welcome to your Turing Application'
    mail(to: user.email, subject: subject) do |format|
      format.html
      format.text
    end
  end

  def quiz(user)
    subject = 'Prepare for the Logic Quiz'
    mail(to: user.email, subject: subject) do |format|
      format.html
      format.text
    end
  end

  def final(user)
    subject = 'Your Turing Application is Complete'
    mail(to: user.email, subject: subject) do |format|
      format.html
      format.text
    end
  end
end