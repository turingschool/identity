class Final
  attr_reader :application,
              :user

  def initialize(user)
    @user        = user
    @application = @user.apply
  end

  def update_attributes
    if application.valid?
      application.complete :final
      application.save

      send_final_email
    else
      false
    end
  end

  def send_final_email
    UserMailer.final(user).deliver
  end
end