require './test/test_helper'
require 'minitest/mock'

class Admin::EvaluationsControllerTest < ActionController::TestCase
  attr_reader :user
  attr_accessor :application

  def setup
    @user = User.create! name: 'Rob', is_admin: true
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

  test 'updates an evaluation' do
    application.update_attribute(:status, 'needs_initial_evaluation_scores')
    evaluation = InitialEvaluation.for(user.application, by: user)
    UpdateEvaluation.stub(:call, false) {
      put :update, { id: evaluation, criteria: 'whatever' }
      assert_equal 'needs_initial_evaluation_scores', application.reload.status
      assert_response :success
      assert_template :edit
    }

    UpdateEvaluation.stub(:call, true) {
      put :update, { id: evaluation, criteria: 'whatever' }
      assert_equal 'needs_rejected_at_initial_evaluation_notification', application.reload.status
      assert_response :redirect
      assert_redirected_to admin_applicant_path(user)
    }
  end
end
