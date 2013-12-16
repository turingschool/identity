class Final
  attr_reader :application
  def initialize(user)
    @application = user.apply
  end

  def update_attributes
    if application.valid?
      application.complete :final
      application.save
    else
      false
    end
  end
end