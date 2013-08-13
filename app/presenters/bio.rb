require 'forwardable'

class Bio
  include ActiveModel::Validations
  extend Forwardable

  validates_presence_of :name, :email, :location

  def_delegators :user, :name, :email, :location

  attr_reader :user
  def initialize(user)
    @user = user
  end

  def update_attributes(attributes)
    user.apply!
    user.update_attributes(attributes)
    if valid?
      user.application.complete! :bio
      true
    else
      false
    end
  end

end
