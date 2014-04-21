require './test/test_helper'

class Admin::EvaluationsControllerTest < ActionController::TestCase
  attr_reader :user, :application

  def setup
    @user = User.create! is_admin: true
    @controller.login user
    @application = user.apply!
  end

  test 'creates an InitialEvaluation' do
    post :create_initial, id: user.id
    assert_response :redirect
    evaluation = application.evaluations.first
    assert_equal 'triage', evaluation.slug
    assert_redirected_to edit_admin_evaluation_path(evaluation)
  end

  test 'creates an InterviewEvaluation' do
    post :create_interview, id: user.id
    assert_response :redirect
    evaluation = application.evaluations.first
    assert_equal 'selection', evaluation.slug
    assert_redirected_to edit_admin_evaluation_path(evaluation)
  end

  test 'creates a LogicEvaluation' do
    post :create_logic, id: user.id
    assert_response :redirect
    evaluation = application.evaluations.first
    assert_equal 'logic', evaluation.slug
    assert_redirected_to edit_admin_evaluation_path(evaluation)
  end
end
