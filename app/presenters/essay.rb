require 'forwardable'

class Essay
  extend Forwardable

  def_delegator :application, :essay_url, :url

  attr_reader :application
  def initialize(user)
    @application = user.apply
  end

  def update_attributes(attributes)
    application.essay_url = attributes[:url]
    application.complete :essay
    application.save
  end
end

