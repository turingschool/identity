require 'forwardable'

class Resume
  extend Forwardable

  def_delegators :application, :resume

  attr_reader :application
  def initialize(user)
    @application = user.apply
  end

  def upload(file)
    application.resume = file
    application.complete :resume
    application.save
    application.resume?
  end
end
