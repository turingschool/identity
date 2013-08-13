require './test/test_helper'

class StepControllerTest < ActionController::TestCase

  def alice
    return @alice if @alice

    data = {
      name: 'Alice Smith',
      email: 'alice@example.com',
      location: 'New York, NY'
    }
    @alice = User.create(data)
  end

  def setup
    @alice = nil
  end

  def test_show_requires_login
    get :show
    assert_redirected_to please_login_path
  end

  def test_redirect_to_next_step
    @controller.login(alice)

    get :show
    assert_redirected_to step_edit_bio_path

    application.complete! :bio
    get :show
    assert_redirected_to step_edit_resume_path

    application.complete! :resume
    get :show
    assert_redirected_to step_edit_essay_path

    application.complete! :essay
    get :show
    assert_redirected_to step_edit_video_path

    application.complete! :video
    get :show
    assert_redirected_to step_edit_quiz_path
  end
end

