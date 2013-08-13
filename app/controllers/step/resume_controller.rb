class Step::ResumeController < StepController
  def show
    @resume = Resume.new(current_user)
  end

  def update
    @resume = Resume.new(current_user)
    if @resume.upload(params[:resume][:file])
      redirect_to step_edit_essay_path
    else
      raise 'whoops'
    end
  end
end

