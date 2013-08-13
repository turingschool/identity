require 'forwardable'

class Resume
  extend Forwardable

  def_delegators :application, :resume

  attr_reader :application
  def initialize(user)
    @user = user
    if user.application
      @application = user.application
    else
      @application = user.build_application
    end
  end

  def upload(file)
    application.resume = file
    application.save
    application.resume?
  end
end
