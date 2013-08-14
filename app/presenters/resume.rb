class Resume
  include ActiveModel::Validations

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
      application.resume?
    else
      false
    end
  end
end
