require './test/test_helper'

class UserTest < ActiveSupport::TestCase
  def test_knows_when_user_is_invited
    # no application
    refute User.new.invited?

    # application not in invited state
    user = User.new &:build_application
    refute user.invited?

    # application in invited state
    user.application.status = ApplicationStateMachine.invited_states.first
    assert user.invited?
  end

  def test_as_json_includes_is_invited
    refute User.new.as_json.fetch(:is_invited)
  end
end
