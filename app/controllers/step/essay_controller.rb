class Step::EssayController < StepController
  def show
    @essay = Essay.new(current_user)
  end

  def update
    @essay = Essay.new(current_user)
    if @essay.update_attributes(essay_params)
      redirect_to step_edit_video_path
    else
      render :show
    end
  end

  private

  def current_step
    :essay
  end

  def essay_params
    params.require(:essay).permit(:url)
  end
end