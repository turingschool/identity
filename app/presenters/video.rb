require 'forwardable'

class Video
  include ActiveModel::Validations
  extend Forwardable

  def_delegator :application, :video_url, :url

  validates_presence_of :url

  attr_reader :application,
              :user

  def initialize(user)
    @user        = user
    @application = @user.apply
  end

  def update_attributes(attributes)
    application.video_url = attributes[:url]
    if valid?
      application.complete :video
      application.save
    else
      false
    end
  end
end

