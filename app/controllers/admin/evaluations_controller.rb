class Admin::EvaluationsController < AdminController

  # Called with the applicant's User ID
  def create_initial
    user        = User.find(params[:id])
    application = user.application
    evaluation  = InitialEvaluation.for(application, by: current_user)

    state_machine = ApplicationStateMachine.new(application.status)
    scores        = application.initial_evaluation_scores
    application.update_attributes(
      status: state_machine.completed_evaluations!(scores)
      )

    redirect_to edit_admin_evaluation_path(evaluation)
  end

  def create_interview
    user        = User.find(params[:id])
    application = user.application
    evaluation  = InterviewEvaluation.for(application, by: current_user)

    state_machine = ApplicationStateMachine.new(application.status)
    scores        = application.interview_scores
    application.update_attributes(
      status: state_machine.completed_interview!(scores)
      )

    redirect_to edit_admin_evaluation_path(evaluation)
  end

  def create_logic
    user        = User.find(params[:id])
    application = user.application
    evaluation  = LogicEvaluation.for(user.application, by: current_user)

    state_machine = ApplicationStateMachine.new(application.status)
    scores        = application.logic_evaluation_scores
    application.update_attributes(
      status: state_machine.completed_logic_evaluation!(scores)
      )

    redirect_to edit_admin_evaluation_path(evaluation)
  end

  def edit
    @evaluation = Evaluation.find(params[:id])
    application = @evaluation.application
    @applicant_actions = Admin::ApplicantActions.new(application, current_user)
    @current_step = application.completed_steps.last
  end

  def update
    @evaluation = Evaluation.find(params[:id])
    if UpdateEvaluation.new(@evaluation, params[:criteria]).save
      redirect_to admin_applicant_path(@evaluation.application.owner)
    else
      render :edit
    end
  end
end
