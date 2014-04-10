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

  def test_initial_status_is_pending
    initial_status = Application.new.status
    assert_equal 'pending', initial_status
    assert ApplicationStateMachine.valid_states.include?(initial_status)
  end

  def test_visibility_scopes
    default_scope = Application.where('id > ?', Application.maximum(:id))
    visible, permahidden, hidden_until_active, both = Application.create [
      { hide_until_active: false, permahide: false },
      { hide_until_active: false, permahide: true  },
      { hide_until_active: true,  permahide: false },
      { hide_until_active: true,  permahide: true  },
    ]
    assert_equal [visible],                      default_scope.visible
    assert_equal [hidden_until_active, both],    default_scope.hidden_until_active
    assert_equal [visible, permahidden],         default_scope.not_hidden_until_active
    assert_equal [permahidden, both],            default_scope.permahidden
    assert_equal [visible, hidden_until_active], default_scope.not_permahidden
  end
end
