class Admin::ApplicantsController < AdminController
  def index
    @step = params[:step]
    @applications = Application.upto(@step)
  end

  def show
    @applicant = User.find params[:id]
    @application = @applicant.application
  end
end
