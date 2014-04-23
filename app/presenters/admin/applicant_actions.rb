module Admin
  class ApplicantActions
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

    def can_interview?
      application.needs_interview? && !application.interviewed_by?(user)
    end

    def can_evaluate_logic?
      application.needs_logic_evaluation? && !application.evaluated_logic_by?(user)
    end

    def can_invite?
      application.needs_invitation?
    end

    def can_respond_invitation?
      application.needs_invitation_response?
    end
  end
end
