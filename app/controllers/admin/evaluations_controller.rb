class Admin::EvaluationsController < AdminController

  # Called with the applicant's User ID
  def create_initial
    user = User.find(params[:id])
    user.application.evaluating!
    evaluation = InitialEvaluation.for(user.application, by: current_user)
    redirect_to edit_admin_evaluation_path(evaluation)
  end

  def create_interview
    user = User.find(params[:id])
    # user.application.evaluating! inject state machine here
    evaluation = InterviewEvaluation.for(user.application, by: current_user)
    redirect_to edit_admin_evaluation_path(evaluation)
  end

  def create_logic
    user = User.find(params[:id])
    # user.application.evaluating! inject state machine here
    evaluation = LogicEvaluation.for(user.application, by: current_user)
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
