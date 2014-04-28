require_relative '../test_helper'

class YouKnowWeHaveASubdomainNowMiddlewareTest < Minitest::Test
  def app
    @app ||= ->(env) { [200, env, "app"] }
  end

  FROM = 'http://asquared.herokuapp.com'
  TO   = 'http://apply.turing.io'

  def middleware
    @middleware ||= YouKnowWeHaveASubdomainNowMiddleware.new(app, from: FROM, to: TO)
  end

  def env_for(url, opts={})
    Rack::MockRequest.env_for(url, opts)
  end

  def test_redirects_from_FROM_to_TO
    code, headers = middleware.call env_for "#{FROM}/some/path"
    assert_equal 301, code
    assert_equal "#{TO}/some/path", headers['Location']
  end

  def test_does_not_redirect_if_from_is_not_FROM
    code, headers, message = middleware.call env_for "#{TO}/some/path"
    assert_equal 200,   code
    assert_equal 'app', message
  end
end
