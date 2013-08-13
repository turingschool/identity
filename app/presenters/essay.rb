require 'forwardable'

class Essay
  extend Forwardable

  def_delegator :application, :essay_url, :url

  attr_reader :application
  def initialize(user)
    if user.application
      @application = user.application
    else
      @application = user.build_application
    end
  end

  def update_attributes(attributes)
    application.essay_url = attributes[:url]
    application.save
  end
end

