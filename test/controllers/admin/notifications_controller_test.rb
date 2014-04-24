require './test/test_helper'

class Admin::NotificationsControllerTest < ActionController::TestCase
  attr_reader :user, :application

  def setup
    @user = User.create! is_admin: true
    @controller.login user
    @application = user.apply!
  end

  test 'it transitions state to rejected_at_initial_evaluation' do
    application.update_attributes(status: 'needs_rejected_at_initial_evaluation_notification')
    post :send_rejection, id: user.id, at: 'initial_evaluation'

    assert_response :redirect
    assert_redirected_to admin_applicant_path(user)
    assert_equal 'rejected_at_initial_evaluation', application.reload.status
  end

  test 'it transitions state to rejected_at_interview' do
    application.update_attributes(status: 'needs_rejected_at_interview_notification')
    post :send_rejection, id: user.id, at: 'interview'

    assert_response :redirect
    assert_redirected_to admin_applicant_path(user)
    assert_equal 'rejected_at_interview', application.reload.status
  end

  test 'it transitions state to rejected_at_logic_evaluation' do
    application.update_attributes(status: 'needs_rejected_at_logic_evaluation_notification')
    post :send_rejection, id: user.id, at: 'logic_evaluation'

    assert_response :redirect
    assert_redirected_to admin_applicant_path(user)
    assert_equal 'rejected_at_logic_evaluation', application.reload.status
  end
end
