require './test/test_helper'

class Admin::EvaluationsControllerTest < ActionController::TestCase
  attr_reader :user
  attr_accessor :application

  def setup
    @user = User.create! is_admin: true
    @controller.login user
    @application = user.apply!
  end

  test 'creates an InitialEvaluation' do
    application.update_attributes(status: 'needs_evaluation_scores')
    post :create_initial, id: user.id
    evaluation = application.evaluations.first

    assert_response :redirect
    assert_equal 'triage', evaluation.slug
    assert_redirected_to edit_admin_evaluation_path(evaluation)
  end

  test 'creates an InterviewEvaluation' do
    application.update_attributes(status: 'needs_interview_scores')
    post :create_interview, id: user.id
    evaluation = application.evaluations.first

    assert_response :redirect
    assert_equal 'selection', evaluation.slug
    assert_redirected_to edit_admin_evaluation_path(evaluation)
  end

  test 'creates a LogicEvaluation' do
    application.update_attributes(status: 'needs_logic_evaluation_scores')
    post :create_logic, id: user.id
    evaluation = application.evaluations.first

    assert_response :redirect
    assert_equal 'logic', evaluation.slug
    assert_redirected_to edit_admin_evaluation_path(evaluation)
  end
end
