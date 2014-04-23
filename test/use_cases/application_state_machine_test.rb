require 'minitest/autorun'
require 'minitest/pride'
require './app/use_cases/application_state_machine'

class ApplicationStateMachineTest < MiniTest::Unit::TestCase
  module StateMachineHelpers
    def machine_for(current_state)
      ApplicationStateMachine.new(current_state)
    end

    def assert_invalid_transition(&block)
      assert_raises ApplicationStateMachine::InvalidTransition, &block
    end
  end

  include StateMachineHelpers

  def test_initialize_requires_a_valid_status
    ApplicationStateMachine.valid_states.each { |state| machine_for state }
    assert_raises ApplicationStateMachine::InvalidState do
      machine_for "not a real state"
    end
  end

  class CompletedApplicationTest < MiniTest::Unit::TestCase
    include StateMachineHelpers

    def test_it_must_be_in_state_pending
      machine_for('pending').submitted!
      assert_invalid_transition { machine_for('needs_initial_evaluation_scores').submitted! }
    end

    def test_it_transitions_the_state_to_needs_initial_evaluation_scores
      assert_equal 'needs_initial_evaluation_scores', machine_for('pending').submitted!
    end
  end

  class CompletedInitialEvaluationsTest < MiniTest::Unit::TestCase
    include StateMachineHelpers

    def test_it_must_be_in_state_needs_initial_evaluation_scores
      # not enough evaluations
      machine_for('needs_initial_evaluation_scores').completed_initial_evaluation!([])
      assert_invalid_transition { machine_for('pending').completed_initial_evaluation!([]) }

      # passing
      machine_for('needs_initial_evaluation_scores').completed_initial_evaluation!([100, 100])
      assert_invalid_transition { machine_for('pending').completed_initial_evaluation!([100, 100]) }

      # failing
      machine_for('needs_initial_evaluation_scores').completed_initial_evaluation!([0, 0])
      assert_invalid_transition { machine_for('pending').completed_initial_evaluation!([0, 0]) }
    end

    def test_if_there_are_fewer_than_1_initial_evaluations_it_does_not_transition_the_state
      assert_equal 'needs_initial_evaluation_scores', machine_for('needs_initial_evaluation_scores').completed_initial_evaluation!([])
      refute_equal 'needs_initial_evaluation_scores', machine_for('needs_initial_evaluation_scores').completed_initial_evaluation!([0])
    end

    def test_if_the_average_score_is_lower_than_10_then_it_transitions_to_needs_rejected_at_initial_evaluation_notification
      assert_equal 'needs_rejected_at_initial_evaluation_notification',
                   machine_for('needs_initial_evaluation_scores').completed_initial_evaluation!([9, 10])
    end

    def test_if_the_average_score_is_greater_than_10_then_it_transitions_to_needs_to_schedule_interview
      assert_equal 'needs_to_schedule_interview',
                   machine_for('needs_initial_evaluation_scores').completed_initial_evaluation!([13, 13])
      assert_equal 'needs_to_schedule_interview',
                   machine_for('needs_initial_evaluation_scores').completed_initial_evaluation!([13, 14])
    end
  end

  class SentRejectedAtInitialEvaluationNotificationTest < MiniTest::Unit::TestCase
    include StateMachineHelpers

    def test_it_must_be_in_state_needs_rejected_at_initial_evaluation_notification
      machine_for('needs_rejected_at_initial_evaluation_notification').sent_rejected_at_initial_evaluation_notification!
      assert_invalid_transition {
        machine_for('pending').sent_rejected_at_initial_evaluation_notification!
      }
    end

    def test_it_transitions_to_rejected_at_initial_evaluation
      assert_equal 'rejected_at_initial_evaluation',
        machine_for('needs_rejected_at_initial_evaluation_notification').sent_rejected_at_initial_evaluation_notification!
    end
  end

  class ScheduledInterviewTest < MiniTest::Unit::TestCase
    include StateMachineHelpers

    def test_it_must_be_in_state_needs_to_schedule_interview
      machine_for('needs_to_schedule_interview').scheduled_interview!
      assert_invalid_transition { machine_for('pending').scheduled_interview!  }
    end

    def test_it_transitions_to_state_needs_interview_scores
      assert_equal 'needs_interview_scores', machine_for('needs_to_schedule_interview').scheduled_interview!
    end
  end

  class CompletedInterviewTest < MiniTest::Unit::TestCase
    include StateMachineHelpers

    def test_it_must_be_in_state_needs_interview_scores
      machine_for('needs_interview_scores').completed_interview!([])
      assert_invalid_transition {
        machine_for('pending').completed_interview!([])
      }
    end

    def test_if_there_are_fewer_than_1_interview_score_it_does_not_transition_the_state
      assert_equal 'needs_interview_scores', machine_for('needs_interview_scores').completed_interview!([])
      refute_equal 'needs_interview_scores', machine_for('needs_interview_scores').completed_interview!([12, 13])
    end

    def test_if_the_average_score_is_lower_than_15_then_it_transitions_to_needs_rejected_at_interview_notification
      assert_equal 'needs_rejected_at_interview_notification',
                   machine_for('needs_interview_scores').completed_interview!([12, 13])
    end

    def test_if_the_average_score_is_greater_than_15_then_it_transitions_to_needs_logic_evaluation_scores
      assert_equal 'needs_logic_evaluation_scores', machine_for('needs_interview_scores').completed_interview!([15, 16])
      assert_equal 'needs_logic_evaluation_scores', machine_for('needs_interview_scores').completed_interview!([20, 14])
    end
  end

  class CompletedLogicEvaluationTest < MiniTest::Unit::TestCase
    include StateMachineHelpers

    def test_it_must_be_in_state_needs_logic_evaluation_scores
      machine_for('needs_logic_evaluation_scores').completed_logic_evaluation!([])
      assert_invalid_transition {
        machine_for('pending').completed_logic_evaluation!([])
      }
    end

    def test_if_there_are_fewer_than_1_logic_evaluation_score_it_does_not_transition_the_state
      assert_equal 'needs_logic_evaluation_scores', machine_for('needs_logic_evaluation_scores').completed_logic_evaluation!([])
      refute_equal 'needs_logic_evaluation_scores', machine_for('needs_logic_evaluation_scores').completed_logic_evaluation!([12, 13])
    end

    def test_if_the_average_score_is_lower_than_10_then_it_transitions_to_needs_rejected_at_logic_evaluation_notification
      assert_equal 'needs_rejected_at_logic_evaluation_notification',
                   machine_for('needs_logic_evaluation_scores').completed_logic_evaluation!([10, 7])
    end

    def test_if_the_average_score_is_greater_than_10_then_it_transitions_to_needs_invitation
      assert_equal 'needs_invitation', machine_for('needs_logic_evaluation_scores').completed_logic_evaluation!([8, 12])
      assert_equal 'needs_invitation', machine_for('needs_logic_evaluation_scores').completed_logic_evaluation!([12])
    end
  end

  class SentRejectedAtInterviewNotificationTest < MiniTest::Unit::TestCase
    include StateMachineHelpers

    def test_it_must_be_in_state_needs_rejected_at_evaluation_notification
      machine_for('needs_rejected_at_interview_notification').sent_rejected_at_interview_notification!
      assert_invalid_transition {
        machine_for('pending').sent_rejected_at_initial_evaluation_notification!
      }
    end

    def test_it_transitions_the_state_to_rejected_at_interview
      assert_equal 'rejected_at_interview',
        machine_for('needs_rejected_at_interview_notification').sent_rejected_at_interview_notification!
    end
  end

  class SentInvitationTest < MiniTest::Unit::TestCase
    include StateMachineHelpers

    def test_it_must_be_in_state_needs_invitation
      machine_for('needs_invitation').sent_invitation!
      assert_invalid_transition { machine_for('pending').sent_invitation!  }
    end

    def test_it_transitions_the_state_to_needs_invitation_response
      assert_equal 'needs_invitation_response', machine_for('needs_invitation').sent_invitation!
    end
  end

  class DeclinedInvitationTest < MiniTest::Unit::TestCase
    include StateMachineHelpers

    def test_it_must_be_in_state_needs_invitation_response
      machine_for('needs_invitation_response').declined_invitation!
      assert_invalid_transition { machine_for('pending').declined_invitation!  }
    end

    def test_it_transitions_the_state_to_declined_invitation
      assert_equal 'declined_invitation', machine_for('needs_invitation_response').declined_invitation!
    end
  end

  class AcceptedInvitationTest < MiniTest::Unit::TestCase
    include StateMachineHelpers

    def test_it_must_be_in_state_invited
      machine_for('needs_invitation_response').accepted_invitation!
      assert_invalid_transition { machine_for('pending').accepted_invitation!  }
    end

    def test_it_transitions_the_state_to_accepted_invitation
      assert_equal 'accepted_invitation', machine_for('needs_invitation_response').accepted_invitation!
    end
  end
end
