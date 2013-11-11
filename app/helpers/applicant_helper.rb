module ApplicantHelper
  def youtube_key(url)
    if url.include?("youtube.com")
      url[/v=([A-z|0-9|\-]*)/, 1]
    else
      url[/youtu.be\/([A-z|0-9|\-]*)/, 1]
    end
  end

  def progress(user)
    completed_steps = user.application.completed_steps.count
    progress = (completed_steps / 5.to_f) * 100
    progress.to_i
  end
end