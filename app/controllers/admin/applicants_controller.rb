class Admin::ApplicantsController < AdminController
  def index
    @step = params[:step]
    @applications = Application.upto(@step).joins(:user)
    @counts = Application.breakdown
  end

  def show
    @applicant = User.find params[:id]
    application = @applicant.application
    @applicant_actions = Admin::ApplicantActions.new(application, current_user)
    @current_step = application.completed_steps.last
  end

  def quiz
    @applicant = User.find params[:id]
    @application = @applicant.application
    @quiz = CompletedQuiz.new(@application.quiz_questions, @application.quiz_answers)
  end

  def by_date
    @step = params[:step]
    @applications = Application.upto(@step).joins(:user).order('applications.updated_at DESC')
    @counts = Application.breakdown

    render :index
  end

  def by_quiz_score
    @step = params[:step]
    @applications = Application.upto(@step).joins(:user).sort_by(&:quiz_score).reverse!
    @counts = Application.breakdown

    render :index
  end

  def by_score
    @step = params[:step]
    @applications = Application.upto(@step).joins(:user).sort_by(&:score).reverse!
    @counts = Application.breakdown

    render :index
  end

  def update
    admin_params = params.require(:user).permit(:hide_until_active, :permahide)
    User.find(params[:id]).application.update_attributes(admin_params)
    render nothing: true
  end
end
