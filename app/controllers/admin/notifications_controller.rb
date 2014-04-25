class Admin::NotificationsController < AdminController
  def send_rejection
    user        = User.find(params[:id])
    application = user.application
    stage       = params[:at]

    state_machine = ApplicationStateMachine.new(application.status)
    application.update_attribute :status, state_machine.send("sent_rejected_at_#{stage}_notification!")

    redirect_to admin_applicant_path(user)
  end
end
