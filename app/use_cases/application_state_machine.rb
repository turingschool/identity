class ApplicationStateMachine
  InvalidState      = Class.new ArgumentError
  InvalidTransition = Class.new StandardError

  def self.transitions
    @transitions ||= {
      # event                                   from_state                                    to_state
      submitted:                                ['pending',                                   'needs_evaluation_scores'],
      not_enough_evaluations:                   ['needs_evaluation_scores',                   'needs_evaluation_scores'],
      passed_evaluations:                       ['needs_evaluation_scores',                   'needs_to_schedule_interview'],
      failed_evaluations:                       ['needs_evaluation_scores',                   'needs_rejected_at_evaluation_notification'],
      sent_rejected_at_evaluation_notification: ['needs_rejected_at_evaluation_notification', 'rejected_at_evaluation'],
      scheduled_interview:                      ['needs_to_schedule_interview',               'needs_interview_scores'],
      not_enough_interviews:                    ['needs_interview_scores',                    'needs_interview_scores'],
      failed_interview:                         ['needs_interview_scores',                    'needs_rejected_at_interview_notification'],
      passed_interview:                         ['needs_interview_scores',                    'needs_invitation'],
      sent_rejected_at_interview_notification:  ['needs_rejected_at_interview_notification',  'rejected_at_interview'],
      sent_invitation:                          ['needs_invitation',                          'needs_invitation_response'],
      declined_invitation:                      ['needs_invitation_response',                 'declined_invitation'],
      accepted_invitation:                      ['needs_invitation_response',                 'accepted_invitation'],
    }
  end

  def self.valid_states
    @valid_states ||= transitions.values.flatten.uniq
  end

  attr_accessor :current_state

  def initialize(current_state)
    self.current_state = current_state
    unless valid_states.include? current_state
      raise InvalidState, "State was #{current_state.inspect}, but was expected to be in #{valid_states.inspect}"
    end
  end

  def submitted!
    transition :submitted
  end

  def completed_evaluations!(evaluation_scores)
    return transition :not_enough_evaluations if evaluation_scores.size < 2
    average = evaluation_scores.inject(0, :+) / evaluation_scores.size
    return transition :failed_evaluations if average < 10
    return transition :passed_evaluations
  end

  def sent_rejected_at_evaluation_notification!
    transition :sent_rejected_at_evaluation_notification
  end

  def scheduled_interview!
    transition :scheduled_interview
  end

  def completed_interview!(interview_scores)
    return transition :not_enough_interviews if interview_scores.size < 1
    average = interview_scores.inject(0, :+) / interview_scores.size
    return transition :failed_interview if average < 15
    return transition :passed_interview
  end

  def sent_rejected_at_interview_notification!
    transition :sent_rejected_at_interview_notification
  end

  def sent_invitation!
    transition :sent_invitation
  end

  def declined_invitation!
    transition :declined_invitation
  end

  def accepted_invitation!
    transition :accepted_invitation
  end

  private

  def transition(event)
    from, to = transitions.fetch event
    assert_state from
    to
  end

  def transitions
    self.class.transitions
  end

  def valid_states
    self.class.valid_states
  end

  def assert_state(expected_state)
    return if current_state == expected_state
    raise InvalidTransition, "Current state is #{current_state.inspect}, but needs to be in #{expected_state.inspect}"
  end
end
