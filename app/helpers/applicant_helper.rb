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
    total_steps = Steps.all.count.to_f
    progress = (completed_steps / total_steps) * 100
    progress.to_i
  end

  def progress_indicator(application)
    application.completed_steps.map { |_| "&#9608" }.join.html_safe
  end

  def completed_steps(user)
    user.application.completed_steps.count
  end
end