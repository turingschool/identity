require './test/test_helper'

module Admin
  class ApplicantActionsTest < ActiveSupport::TestCase
    def presenter_for(application, user = User.new)
      ApplicantActions.new(application, user)
    end

    def application_with_data
      @application_with_data ||= Application.new do |app|
        def app.resume_url
          'RESUME URL'
        end
        app.essay_url       = 'ESSAY URL'
        app.video_url       = 'VIDEO URL'
        app.quiz_questions  = %w(a b)
        app.quiz_answers    = %w(a b)
        app.completed_steps = Steps.all.map(&:to_s)
      end
    end

    def application_without_data
      @application_without_data ||= Application.new
    end

    test 'it knows if the application has a resume' do
      assert presenter_for(application_with_data).has_resume?
      refute presenter_for(application_without_data).has_resume?
    end

    test 'it provides the resume url' do
      presenter = presenter_for(application_with_data)
      assert_equal 'RESUME URL', presenter.resume_url
    end

    test 'it knows if the application has an essay' do
      assert presenter_for(application_with_data).has_essay?
      refute presenter_for(application_without_data).has_essay?
    end

    test 'it provides the essay url' do
      presenter = presenter_for(application_with_data)
      assert_equal 'ESSAY URL', presenter.essay_url
    end

    test 'it knows if the application has a video' do
      assert presenter_for(application_with_data).has_video?
      refute presenter_for(application_without_data).has_video?
    end

    test 'it provides the video url' do
      presenter = presenter_for(application_with_data)
      assert_equal 'VIDEO URL', presenter.video_url
    end

    test 'it knows if the quiz is complete' do
      assert presenter_for(application_with_data).quiz_complete?
      refute presenter_for(application_without_data).quiz_complete?
    end

    test 'it knows the quiz score' do
      application = Application.new
      application.quiz_answers = {
        question_1: { result: true },
        question_2: { result: true },
        question_3: { result: false },
        question_4: { result: true }
      }
      presenter = presenter_for(application)
      assert_equal application.quiz_score,
                   presenter.quiz_score
    end

    test 'it knows the quiz size' do
      presenter = presenter_for(application_with_data)
      assert_equal application_with_data.quiz_size,
                   presenter.quiz_size
    end

    test 'it says the user can create an evaluation' do
      application  = Application.create!(status: 'needs_initial_evaluation_scores')
      current_user = User.create!

      # does not need evaluation, is not evaluated by current user
      refute presenter_for(application_without_data).can_evaluate?

      # needs evaluation, was evaluated by current user
      application.initial_evaluations.create(user_id: current_user.id)
      presenter = presenter_for application, current_user
      refute presenter.can_evaluate?

      # needs evaluation, was not interviewed by current user
      application.evaluations.clear
      presenter = presenter_for(application, current_user)
      assert presenter.can_evaluate?
    end

    test 'it can send a rejected at initial evaluation notification' do
      application  = Application.new(status: 'needs_rejected_at_initial_evaluation_notification')
      current_user = User.new

      # does not need to send a rejected at initial evaluation notification
      refute presenter_for(application_without_data).can_send_rejected_at_initial_evaluation_notification?

      # needs to send a rejected at initial evaluation notification
      assert presenter_for(application, current_user).can_send_rejected_at_initial_evaluation_notification?
    end

    test 'it can schedule an interview' do
      application  = Application.create!(status: 'needs_to_schedule_interview')
      current_user = User.create!

      # does not need to schedule interview
      refute presenter_for(application_without_data).can_schedule_interview?

      # needs to schedule interview
      assert presenter_for(application, current_user).can_schedule_interview?
    end

    test 'it says the user can create interview' do
      application  = Application.create!(status: 'needs_interview_scores')
      current_user = User.create!

      # does not need interview, is not evaluated by current user
      refute presenter_for(application_without_data).can_interview?

      # needs interview, was interviewed by current user
      application.interviews.create(user_id: current_user.id)
      presenter = presenter_for(application, current_user)
      refute presenter.can_interview?

      # needs interview, was not interviewed by current user
      application.evaluations.clear
      presenter = presenter_for(application, current_user)
      assert presenter.can_interview?
    end

    test 'it can send a rejected at interview notification' do
      application  = Application.new(status: 'needs_rejected_at_interview_notification')
      current_user = User.new

      # does not need to send a rejected at interview notification
      refute presenter_for(application_without_data).can_send_rejected_at_interview_notification?

      # needs to send a rejected at interview notification
      assert presenter_for(application, current_user).can_send_rejected_at_interview_notification?
    end

    test 'it can create a logic evaluation' do
      application  = Application.create!(status: 'needs_logic_evaluation_scores')
      current_user = User.create!

      # does not need interview, is not evaluated by current user
      refute presenter_for(application_without_data).can_evaluate_logic?

      # needs interview, was interviewed by current user
      application.logic_evaluations.create(user_id: current_user.id)
      presenter = presenter_for(application, current_user)
      refute presenter.can_evaluate_logic?

      # needs interview, was not interviewed by current user
      application.evaluations.clear
      presenter = presenter_for(application, current_user)
      assert presenter.can_evaluate_logic?
    end

    test 'it can send a rejected at logic evaluation notification' do
      application  = Application.new(status: 'needs_rejected_at_logic_evaluation_notification')
      current_user = User.new

      # does not need to send a rejected at logic evaluation notification
      refute presenter_for(application_without_data).can_send_rejected_at_logic_evaluation_notification?

      # needs to send a rejected at logic evaluation notification
      assert presenter_for(application, current_user).can_send_rejected_at_logic_evaluation_notification?
    end

    test 'it can invite' do
      application  = Application.create!(status: 'needs_invitation')
      current_user = User.create!

      # does not need invitation
      refute presenter_for(application_without_data).can_invite?

      # needs invitation
      assert presenter_for(application, current_user).can_invite?
    end

    test 'it can respond invitation' do
      application  = Application.create(status: 'needs_invitation_response')
      current_user = User.create!

      # does not need invitation response
      refute presenter_for(application_without_data).can_respond_invitation?

      # needs invitation response
      assert presenter_for(application, current_user).can_respond_invitation?
    end
  end
end
