module Admin
  class ApplicantActions

    # FIXME: Currently methods based on the application state will prevent
    # things that we probably want to allow. E.g. can_evaluate? will return
    # false after a sufficient number of admin have evaluated the applicant,
    # preventing additional admin from evaluating it.
    #
    # Leaving this for now, b/c it is convenient in that the state machine
    # would not handle the event correctly anyway (would blow up),
    # but when we come back later address this flaw in the state machine,
    # we should also look into what the correct logic should be for these methods
    #
    # An issue should exist for all of this.

    extend Forwardable
    attr_reader :application, :user

    def_delegators :application,
                   :essay_url,
                   :quiz_complete?,
                   :quiz_score,
                   :quiz_size,
                   :resume_url,
                   :video_url


    def initialize(application, user)
      @application = application
      @user        = user
    end

    def has_resume?
      !!resume_url
    end

    def has_essay?
      !!essay_url
    end

    def has_video?
      !!video_url
    end

    def can_evaluate?
      application.needs_initial_evaluation? && !application.evaluated_by?(user)
    end

    def can_send_rejected_at_initial_evaluation_notification?
      application.needs_rejected_at_initial_evaluation_notification?
    end

    def can_schedule_interview?
      application.needs_to_schedule_interview?
    end

    def can_interview?
      application.needs_interview? && !application.interviewed_by?(user)
    end

    def can_send_rejected_at_interview_notification?
      application.needs_rejected_at_interview_notification?
    end

    def can_evaluate_logic?
      application.needs_logic_evaluation? && !application.evaluated_logic_by?(user)
    end

    def can_send_rejected_at_logic_evaluation_notification?
      application.needs_rejected_at_logic_evaluation_notification?
    end

    def can_invite?
      application.needs_invitation?
    end

    def can_respond_invitation?
      application.needs_invitation_response?
    end
  end
end
