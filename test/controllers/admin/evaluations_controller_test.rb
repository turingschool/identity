require './test/test_helper'

class Admin::EvaluationsControllerTest < ActionController::TestCase
  attr_reader :user, :application

  def setup
    @user = User.create!
    @controller.login user
    @application = user.apply!
  end

  test "creates an InitialEvaluation" do
    post :create_initial, id: user.id
    assert_response :redirect
  end

  test "creates an InterviewEvaluation" do
    post :create_interview, id: user.id
    assert_response :redirect
  end

  test "creates an LogicEvaluation" do
    post :create_logic, id: user.id
    assert_response :redirect
  end
end
