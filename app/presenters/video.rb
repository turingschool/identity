require 'forwardable'

class Video
  extend Forwardable

  def_delegator :application, :video_url, :url

  attr_reader :application
  def initialize(user)
    if user.application
      @application = user.application
    else
      @application = user.build_application
    end
  end

  def update_attributes(attributes)
    application.video_url = attributes[:url]
    application.complete :video
    application.save
  end
end

