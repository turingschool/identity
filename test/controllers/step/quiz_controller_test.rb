require './test/test_helper'

class Step::QuizControllerTest < ActionController::TestCase

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

  def test_update_quiz
    skip 'no idea how this is going to work'
  end
end

