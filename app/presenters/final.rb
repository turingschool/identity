# this should be a use case, not a presenter
# should probably have its own tests
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
      application.completed_application!
    else
      false
    end
  end
end
