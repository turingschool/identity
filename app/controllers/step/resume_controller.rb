class Step::ResumeController < StepController
  def show
    @resume = Resume.new(current_user)
  end

  def update
    @resume = Resume.new(current_user)
    if @resume.upload(resume_params)
      redirect_to step_edit_essay_path
    else
      render :show
    end
  end

  private

  def current_step
    :resume
  end

  def resume_params
    params.fetch(:resume) { nil }
  end

end

