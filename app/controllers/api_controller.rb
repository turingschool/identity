class ApiController < ApplicationController
  skip_before_filter :require_login
  before_filter      :authenticate_client

  # an endpoint you can ping to make sure everything is setup
  def marco
    render text: 'polo'
  end

  private

  def authenticate_client
    authenticate_or_request_with_http_basic do |name, secret|
      RemoteClient.find_by name: name, secret: secret
    end
  end
end
