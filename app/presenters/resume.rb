require 'forwardable'

class Resume
  include ActiveModel::Validations
  extend Forwardable

  validates_presence_of :file

  attr_reader :application, :file
  def initialize(user)
    @application = user.apply
  end

  def upload(file)
    @file = file
    application.resume = file
    if valid? && application.valid?
      application.complete :resume
      application.save
    else
      false
    end
  end
end
