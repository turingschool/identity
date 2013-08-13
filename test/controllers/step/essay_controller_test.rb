require './test/test_helper'

class Step::EssayControllerTest < ActionController::TestCase

  def alice
    @alice ||= User.create
  end

  def setup
    @alice = nil
  end

  def test_show_requires_login
    get :show
    assert_redirected_to please_login_path
  end

  def test_update_requires_login
    put :update
    assert_redirected_to please_login_path
  end

  def test_update_essay_url
    @controller.login(alice)
    put :update, essay: {url: "http://example.com/essay"}

    assert_equal 'http://example.com/essay', alice.application.essay_url
    assert_redirected_to step_edit_video_path
  end
end

