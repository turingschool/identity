require 'forwardable'

class Essay
  include ActiveModel::Validations
  extend Forwardable

  def_delegator :application, :essay_url, :url

  validates_presence_of :url

  attr_reader :application
  def initialize(user)
    @application = user.apply
  end

  def update_attributes(attributes)
    application.essay_url = attributes[:url]
    if valid?
      application.complete :essay
      application.save
    else
      false
    end
  end
end

