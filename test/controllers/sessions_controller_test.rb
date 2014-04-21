require './test/test_helper'
require 'minitest/mock'

class SessionsControllerTest < ActionController::TestCase
  def test_return_url_is_stored_in_the_session
    response = get :new, return_url: 'some url'
    assert_equal 'some url', session[:return_url]
  end

  def test_when_returning_from_github_we_will_redirect_them_to_the_return_url
    Authentication.stub(:perform, User.new) do
      session[:return_url] = 'http://www.google.com'
      response = get :callback
      assert_equal 'http://www.google.com', response.redirect_url
      refute session[:return_url]
    end
  end
end
