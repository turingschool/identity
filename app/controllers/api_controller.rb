class ApiController < ApplicationController
  skip_before_filter :require_login
  before_filter      :authenticate_client
  protect_from_forgery with: :null_session

  # an endpoint you can ping to make sure everything is setup
  def marco
    render text: 'polo'
  end

  private

  def authenticate_client
    authenticate_or_request_with_http_basic do |name, secret|
      if name == 'test_username' && secret == 'test_secret' && Rails.env.test?
        true
      else
        RemoteClient.find_by name: name, secret: secret
      end
    end
  end
end
