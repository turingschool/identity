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
      application.completed!
    else
      false
    end
  end
end
