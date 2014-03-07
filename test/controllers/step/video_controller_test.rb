require './test/test_helper'

class Step::VideoControllerTest < ActionController::TestCase
  def alice
    @alice ||= User.create(email: "alice@example.com")
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

  def test_update_video_url
    @controller.login(alice)
    application = alice.apply
    application.complete :bio
    application.complete :resume
    application.complete :essay
    application.save

    put :update, video: {url: "http://example.com/video"}

    application.reload

    assert_redirected_to step_edit_quiz_path
    assert_equal 'http://example.com/video', application.video_url
    assert application.completed? :video
  end
end