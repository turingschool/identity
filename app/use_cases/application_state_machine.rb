class ApplicationStateMachine
  InvalidState      = Class.new ArgumentError
  InvalidTransition = Class.new StandardError

  def self.transitions
    @transitions ||= {
      # event                                         from_state                                              to_state
      submitted:                                        ['pending',                                           'needs_initial_evaluation_scores'],
      not_enough_initial_evaluations:                   ['needs_initial_evaluation_scores',                   'needs_initial_evaluation_scores'],
      passed_initial_evaluations:                       ['needs_initial_evaluation_scores',                   'needs_to_schedule_interview'],
      failed_initial_evaluations:                       ['needs_initial_evaluation_scores',                   'needs_rejected_at_initial_evaluation_notification'],
      sent_rejected_at_initial_evaluation_notification: ['needs_rejected_at_initial_evaluation_notification', 'rejected_at_initial_evaluation'],

      scheduled_interview:                              ['needs_to_schedule_interview',                       'needs_interview_scores'],
      not_enough_interviews:                            ['needs_interview_scores',                            'needs_interview_scores'],
      failed_interview:                                 ['needs_interview_scores',                            'needs_rejected_at_interview_notification'],
      passed_interview:                                 ['needs_interview_scores',                            'needs_logic_evaluation_scores'],
      sent_rejected_at_interview_notification:          ['needs_rejected_at_interview_notification',          'rejected_at_interview'],

      not_enough_logic_evaluations:                     ['needs_logic_evaluation_scores',                     'needs_logic_evaluation_scores'],
      failed_logic_evaluation:                          ['needs_logic_evaluation_scores',                     'needs_rejected_at_logic_evaluation_notification'],
      passed_logic_evaluation:                          ['needs_logic_evaluation_scores',                     'needs_invitation'],
      sent_rejected_at_logic_evaluation_notification:   ['needs_rejected_at_logic_evaluation_notification',   'rejected_at_logic_evaluation'],

      sent_invitation:                                  ['needs_invitation',                                  'needs_invitation_response'],
      declined_invitation:                              ['needs_invitation_response',                         'declined_invitation'],
      accepted_invitation:                              ['needs_invitation_response',                         'accepted_invitation'],
    }
  end

  def self.valid_states
    @valid_states ||= transitions.values.flatten.uniq
  end

  def self.invited_states
    @invited_states ||= %w[needs_invitation
                           needs_invitation_response
                           accepted_invitation
                           declined_invitation]
  end

  def self.complete_states
    @complete_states ||= valid_states.select{|s| s.include?('rejected') || s.include?('invitation')}
  end

  validate = -> values do
    values.each do |value|
      next if valid_states.include? value
      raise "#{value.inspect} is not in #{valid_states.inspect}"
    end
  end
  validate.call invited_states

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

  def completed_initial_evaluation!(evaluation_scores)
    return transition :not_enough_initial_evaluations if evaluation_scores.size < 1
    average = evaluation_scores.inject(0, :+) / evaluation_scores.size
    return transition :failed_initial_evaluations if average < 10
    return transition :passed_initial_evaluations
  end

  def sent_rejected_at_initial_evaluation_notification!
    transition :sent_rejected_at_initial_evaluation_notification
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

  def completed_logic_evaluation!(logic_scores)
    return transition :not_enough_logic_evaluations if logic_scores.size < 1
    average = logic_scores.inject(0, :+) / logic_scores.size
    return transition :failed_logic_evaluation if average < 10
    return transition :passed_logic_evaluation
  end

  def sent_rejected_at_logic_evaluation_notification!
    transition :sent_rejected_at_logic_evaluation_notification
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
