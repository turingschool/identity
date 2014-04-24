class Admin::EvaluationsController < AdminController

  # Called with the applicant's User ID
  def create_initial
    user        = User.find(params[:id])
    evaluation  = InitialEvaluation.for(user.application, by: current_user)

    redirect_to edit_admin_evaluation_path(evaluation)
  end

  def create_interview
    user        = User.find(params[:id])
    evaluation  = InterviewEvaluation.for(user.application, by: current_user)

    redirect_to edit_admin_evaluation_path(evaluation)
  end

  def create_logic
    user        = User.find(params[:id])
    evaluation  = LogicEvaluation.for(user.application, by: current_user)

    redirect_to edit_admin_evaluation_path(evaluation)
  end

  def edit
    @evaluation = Evaluation.find(params[:id])
    application = @evaluation.application
    set_edit_attributes(application)
  end

  def update
    @evaluation = Evaluation.find(params[:id])
    if UpdateEvaluation.call(@evaluation, params[:criteria])
      update_application_state(@evaluation)
      redirect_to admin_applicant_path(@evaluation.application.owner)
    else
      set_edit_attributes(@evaluation.application)
      render :edit
    end
  end

  private

  def update_application_state(evaluation)
    application   = evaluation.application
    state_machine = ApplicationStateMachine.new(application.status)
    scores        = application.send("#{evaluation.slug}_scores")

    application.update_attributes(
      status: state_machine.send("completed_#{evaluation.slug}!", scores)
      )
  end

  def set_edit_attributes(application)
    @applicant_actions = Admin::ApplicantActions.new(application, current_user)
    @current_step = application.completed_steps.last
  end
end
