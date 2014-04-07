class Admin::EvaluationsController < AdminController

  # Called with the applicant's User ID
  def create
    user = User.find(params[:id])
    user.application.evaluating!
    evaluation = evaluation(user)
    redirect_to edit_admin_evaluation_path(evaluation)
  end

  def edit
    @evaluation = Evaluation.find(params[:id])
    @current_step = @evaluation.application.completed_steps.last
  end

  def update
    @evaluation = Evaluation.find(params[:id])
    if UpdateEvaluation.new(@evaluation, params[:criteria]).save
      redirect_to admin_applicant_path(@evaluation.application.owner)
    else
      render :edit
    end
  end

  private

  def evaluation(user)
    if params[:interview]
      evaluation = InterviewEvaluation
    else
      evaluation = InitialEvaluation
    end

    evaluation.for(user.application, by: current_user)
  end
end