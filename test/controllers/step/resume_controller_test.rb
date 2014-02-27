require './test/test_helper'

class Step::ResumeControllerTest < ActionController::TestCase

  def alice
    @alice ||= User.create(name: "Alice Smith")
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

  def test_upload_resume
    @controller.login(alice)

    application = alice.apply
    application.complete :bio
    application.save

    file = fixture_file_upload('hello.pdf', 'application/pdf')
    put :update, resume: {file: file}

    application.reload

    assert_redirected_to step_edit_essay_path
    assert application.resume?, "Resume is missing"
    assert application.resume_url.end_with? "alice-smith.pdf"
    assert application.completed? :resume
  end
end

