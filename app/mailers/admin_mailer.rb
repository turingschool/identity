class AdminMailer < ActionMailer::Base
  default from: "\"Turing School\" <contact@turing.io>"

  def application_submitted(user)
    @user = user
    admin_emails = User.where(is_admin: true).pluck(:email)
    admin_emails.each do |admin_email|
      mail(
        to: admin_email,
        subject: "#{@user.name} submitted an Application"
        )
    end
  end
end