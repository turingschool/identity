class Admin::InvitationsController < AdminController

  # Probably refactor to something like this
  # Update controllers
  #   Invitations
  #     create
  #     update?result=accept
  #     update?result=decline
  #   Interviews
  #     create

  # Called with the applicant's User ID
  def create
    user        = User.find(params[:id])
    application = user.application

    state_machine = ApplicationStateMachine.new(application.status)
    application.update_attribute :status, state_machine.sent_invitation!

    redirect_to admin_applicant_path(user)
  end

  def schedule_interview
    user        = User.find(params[:id])
    application = user.application

    state_machine = ApplicationStateMachine.new(application.status)
    application.update_attribute :status, state_machine.scheduled_interview!

    redirect_to admin_applicant_path(user)
  end

  def accept
    user        = User.find(params[:id])
    application = user.application

    state_machine = ApplicationStateMachine.new(application.status)
    application.update_attribute :status, state_machine.accepted_invitation!

    redirect_to admin_applicant_path(user)
  end

  def decline
    user        = User.find(params[:id])
    application = user.application

    state_machine = ApplicationStateMachine.new(application.status)
    application.update_attribute :status, state_machine.declined_invitation!

    redirect_to admin_applicant_path(user)
  end
end
