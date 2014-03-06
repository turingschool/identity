class Step::VideoController < StepController
  def show
    @video = Video.new(current_user)
  end

  def update
    @video = Video.new(current_user)
    if @video.update_attributes(video_params)
      UserMailer.quiz(current_user).deliver
      redirect_to step_edit_quiz_path
    else
      render :show
    end
  end

  private

  def current_step
    :video
  end

  def video_params
    params.require(:video).permit(:url)
  end
end