require './test/test_helper'

class Step::BioControllerTest < ActionController::TestCase

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

  def test_update_requires_login
    put :update
    assert_redirected_to please_login_path
  end

  def test_update_biographical_data
    updated = {
      name: 'Alice J. Smith',
      email: 'alice.j.smith@example.com',
      location: 'Houston, TX'
    }

    @controller.login(alice)
    put :update, bio: updated

    alice.reload
    assert_equal 'Alice J. Smith', alice.name
    assert_equal 'alice.j.smith@example.com', alice.email
    assert_equal 'Houston, TX', alice.location
  end

  def test_cannot_become_admin
    refute alice.admin?

    @controller.login(alice)
    put :update, bio: {is_admin: true}

    refute alice.reload.admin?
  end
end

