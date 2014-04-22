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
      state_machine = ApplicationStateMachine.new status
      application.update_attributes(status: state_machine.submitted!)
    else
      false
    end
  end
end
