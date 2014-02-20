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

  def by_date
    @step = params[:step]
    @applications = Application.upto(@step).order(updated_at: :desc)
    @counts = Application.breakdown

    render :index
  end

  def by_score
    @step = params[:step]
    @applications = Application.upto(@step).sort_by(&:quiz_score).reverse!
    @counts = Application.breakdown

    render :index
  end
end
