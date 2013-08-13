require 'forwardable'

class Bio
  extend Forwardable

  def_delegators :user, :name, :email, :location

  attr_reader :user
  def initialize(user)
    @user = user
  end

  def update_attributes(attributes)
    user.apply!
    if user.update_attributes(attributes)
      user.application.complete! :bio
      true
    else
      false
    end
  end
end
