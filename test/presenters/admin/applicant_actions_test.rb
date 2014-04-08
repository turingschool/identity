require './test/test_helper'
require './app/presenters/admin/applicant_actions'

module Admin
  class ApplicantActionsTest < ActiveSupport::TestCase
    def presenter_for(application, user=User.new)
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

    test 'it says the user can create an evaluation if the application is complete and they have not yet evaluated it' do
      application = Application.create! completed_steps: Steps.all.map(&:to_s)
      current_user = User.create!

      # not complete, is not evaluated by current user
      refute presenter_for(application_without_data).can_evaluate?

      # is complete, is evaluated by current user
      application.evaluations.create(user_id: current_user.id)
      presenter = presenter_for application, current_user
      refute presenter.can_evaluate?

      # is complete, is not evaluated by current user
      application.evaluations.clear
      presenter = presenter_for(application, current_user)
      assert presenter.can_evaluate?
    end

    test 'it says the user can create interview notes if the application is complete and they have not yet interviewed' do
      application = Application.create!
      user = User.create!

      # Doesn't have any evaluations
      presenter = presenter_for(application)
      refute presenter.can_interview?

      # Is being evaluated,
      # and the current user has not already interviewed the applicant
      evaluation = application.evaluations.build
      presenter  = presenter_for(application, user)
      refute presenter.can_interview?


      # Has been evaluated,
      # and the current user has already interviewed the applicant
      evaluation.completed_at = Time.now
      application.interview_notes.create! do |e|
        e.user = user
        e.slug = 'selection'
      end

      presenter = presenter_for(application, user)
      refute presenter.can_interview?


      # Has been evaluated,
      # and that the current user has not interviewed the applicant
      presenter = presenter_for(application, User.new)
      assert presenter.can_interview?
    end
  end
end