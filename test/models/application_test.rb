require './test/test_helper'

class ApplicationTest < ActiveSupport::TestCase
  def test_serializes_application_steps
    app = Application.create(completed_steps: %w(one two))
    app.reload
    assert_equal %w(one two), app.completed_steps
  end

  def test_owner_slug
    user = User.new(name: 'Alice Smith')
    app = Application.new(user: user)
    assert_equal 'alice-smith', app.owner_slug
  end

  def test_step_completion
    app = Application.new
    app.complete :bio
    assert app.completed? :bio
  end

end
