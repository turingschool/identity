class Admin::ApplicantsController < AdminController
  def index
    @step = params[:step]
    @applications = Application.upto(@step)
    @counts = Application.breakdown
  end

  def show
    @applicant = User.find params[:id]
    @current_step = @applicant.application.completed_steps.last
  end
end
