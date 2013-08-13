class Step::VideoController < ApplicationController
  before_filter :require_login

  def show
    @video = Video.new(current_user)
  end

  def update
    video = Video.new(current_user)
    if video.update_attributes(video_params)
      redirect_to root_path
    else
      raise 'whoops'
    end
  end

  private

  def video_params
    params.require(:video).permit(:url)
  end

end
