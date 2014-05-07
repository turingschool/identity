require './test/test_helper'

class ApplicationTest < ActiveSupport::TestCase
  def test_serializes_application_steps
    app = Application.create(completed_steps: %w(one two))
    app.reload
    assert_equal %w(one two), app.completed_steps
  end

  def test_fetches_all_applications_on_step
    user_1 = User.create(name: 'Roberto')
    user_2 = User.create(name: 'Luis')

    app_1 = Application.create(user_id: user_1.id, completed_steps: %w(one two three))
    app_2 = Application.create(user_id: user_2.id, completed_steps: %w(one two three))
    apps  = [app_1, app_2]

    app_3 = Application.create(completed_steps: %w(one two))

    result = Application.all_by_step('three')
    assert_equal 2, result.count
    assert apps.each { |app| result.include?(app) }
    refute apps.include?(app_3)
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
    application = Application.new
    initial_status = application.status
    assert application.valid?
    assert_equal 'pending', initial_status
    assert ApplicationStateMachine.valid_states.include?(initial_status)
  end

  def test_it_needs_initial_evaluation
    app = Application.new(status: 'needs_initial_evaluation_scores')
    assert app.valid?
    assert app.needs_initial_evaluation?
  end

  def test_it_needs_rejected_at_initial_evaluation_notification
    app = Application.new(status: 'needs_rejected_at_initial_evaluation_notification')
    assert app.valid?
    assert app.needs_rejected_at_initial_evaluation_notification?
  end

  def test_it_needs_to_schedule_interview
    app = Application.new(status: 'needs_to_schedule_interview')
    assert app.valid?
    assert app.needs_to_schedule_interview?
  end

  def test_it_needs_interview
    app = Application.new(status: 'needs_interview_scores')
    assert app.valid?
    assert app.needs_interview?
  end

  def test_it_needs_rejected_at_interview_notification
    app = Application.new(status: 'needs_rejected_at_interview_notification')
    assert app.valid?
    assert app.needs_rejected_at_interview_notification?
  end

  def test_it_needs_logic_evaluation
    app = Application.new(status: 'needs_logic_evaluation_scores')
    assert app.valid?
    assert app.needs_logic_evaluation?
  end

  def test_it_needs_rejected_at_logic_evaluation_notification
    app = Application.new(status: 'needs_rejected_at_logic_evaluation_notification')
    assert app.valid?
    assert app.needs_rejected_at_logic_evaluation_notification?
  end

  def test_it_needs_invitation
    app = Application.new(status: 'needs_invitation')
    assert app.valid?
    assert app.needs_invitation?
  end

  def test_it_needs_invitation_response
    app = Application.new(status: 'needs_invitation_response')
    assert app.valid?
    assert app.needs_invitation_response?
  end

  def test_status_must_be_in_application_state_machine
    application = Application.new
    ApplicationStateMachine.valid_states.each do |state|
      application.status = state
      application.valid?
      assert application.errors[:status].empty?
    end
    application.status = 'not_a_status'
    application.valid?
    errors = application.errors[:status]
    assert_equal 1, errors.size
    assert errors.first['not_a_status']
  end

  def test_visibility_scopes
    total_applications = Application.count
    default_scope = Application.where('id > ?', total_applications)
    visible, permahidden, hidden_until_active, both = Application.create! [
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

  def test_invited_apps_are_not_collected_in_steps
    user_1 = User.create(name: 'Roberto')
    user_2 = User.create(name: 'Luis')

    app_complete = Application.create(user_id: user_1.id, status: 'needs_invitation_response', completed_steps: %w(one two three))
    app_incomplete = Application.create(user_id: user_2.id, status: 'needs_initial_evaluation_scores', completed_steps: %w(one two three))
    assert_equal 2, Application.count
    assert_equal 1, Application.all_by_step('three').count
    assert_equal app_incomplete, Application.all_by_step('three').first
  end
end
