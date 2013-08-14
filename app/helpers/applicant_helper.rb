module ApplicantHelper
  def youtube_key(url)
    if url.include?("youtube.com")
      url[/v=([A-z|0-9|\-]*)/, 1]
    else
      url[/youtu.be\/([A-z|0-9|\-]*)/, 1]
    end
  end
end
