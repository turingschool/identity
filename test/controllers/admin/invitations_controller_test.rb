require './test/test_helper'

class Admin::InvitationsControllerTest < ActionController::TestCase
  attr_reader :user, :application

  def setup
    @user = User.create! is_admin: true
    @controller.login user
    @application = user.apply!
  end

  def test_it_creates_an_invite
    application.update_attributes(status: 'needs_invitation')
    post :create, id: user.id

    assert_response :redirect
    assert_redirected_to admin_applicant_path(user)
    assert_equal 'needs_invitation_response', application.reload.status
  end

  def test_it_schedules_an_interview
    application.update_attributes(status: 'needs_to_schedule_interview')
    post :schedule_interview, id: user.id

    assert_response :redirect
    assert_redirected_to admin_applicant_path(user)
    assert_equal 'needs_interview_scores', application.reload.status
  end

  def test_it_accepts_an_invite
    application.update_attributes(status: 'needs_invitation_response')
    post :accept, id: user.id

    assert_response :redirect
    assert_redirected_to admin_applicant_path(user)
    assert_equal 'accepted_invitation', application.reload.status
  end

  def test_it_declines_an_invite
    application.update_attributes(status: 'needs_invitation_response')
    post :decline, id: user.id

    assert_response :redirect
    assert_redirected_to admin_applicant_path(user)
    assert_equal 'declined_invitation', application.reload.status
  end
end
