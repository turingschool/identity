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
    post :create_initial, id: user.id
    evaluation = application.evaluations.first

    assert_response :redirect
    assert_equal 'initial_evaluation', evaluation.slug
    assert_redirected_to edit_admin_evaluation_path(evaluation)
  end

  test 'creates an InterviewEvaluation' do
    post :create_interview, id: user.id
    evaluation = application.evaluations.first

    assert_response :redirect
    assert_equal 'interview', evaluation.slug
    assert_redirected_to edit_admin_evaluation_path(evaluation)
  end

  test 'creates a LogicEvaluation' do
    post :create_logic, id: user.id
    evaluation = application.evaluations.first

    assert_response :redirect
    assert_equal 'logic_evaluation', evaluation.slug
    assert_redirected_to edit_admin_evaluation_path(evaluation)
  end
end
