class Step::EssayController < ApplicationController
  before_filter :require_login

  def show
    @essay = Essay.new(current_user)
  end

  def update
    @essay = Essay.new(current_user)
    if @essay.update_attributes(essay_params)
      redirect_to step_edit_video_path
    else
      raise 'whoops'
    end
  end

  private

  def essay_params
    params.require(:essay).permit(:url)
  end

end
