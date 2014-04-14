require './test/test_helper'
require './test/helpers/feature'

class Admin::ApplicationFlowTest < MiniTest::Unit::TestCase
  include Test::Helpers::Feature

  def admin1
    @admin1 ||= User.create! name: 'admin1', location: 'here', is_admin: true
  end

  def admin2
    @admin2 ||= User.create! name: 'admin2', location: 'here', is_admin: true
  end

  def user
    @user ||= User.create! name: 'user1',  location: 'here' do |user|
      application        = user.apply
      application.status = 'needs_interview_scores'
    end
  end

  def test_happy_path
    set_current_user admin1
    result = page.visit url_helpers.admin_applicant_path(user)
    page.click_on 'Create Evaluation'
    # should see "Initial Evaluation"
    # page.click_on 'Save Evaluation'
    # should be in needs_to_schedule_interview
    # mark that interview is scheduled
    # should be in needs_interview_scores
    #
    # submit two interview scores
    #   page.click_on 'Create Interview Notes'
    #   should see "Interview Notes"
    #   page.click_on 'Save Evaluation'
    #   page.click_on 'Create Logic Evaluation'
    #   should see "Logical Reasoning"
    #   page.click_on 'Save Evaluation'
    #
    # should be in needs_invitation
    # mark that they are invited
    # should be in needs_invitation_response
    # mark that they accepted the invitation
  end

  def test_rejected_at_evaluation
    # needs_evaluation_scores ->
    # needs_rejected_at_evaluation_notification ->
    # needs_rejected_at_evaluation
    skip
  end

  def test_rejected_at_interview
    # needs_interview_scores ->
    # needs_rejected_at_interview_notification ->
    # rejected_at_interview
    skip
  end

  def test_declined_invitation
    # needs_invitation_response ->
    # declined_invitation
    skip
  end

  # ADDITIONAL (maybe)
  # when you update your evaluation, it should potentially
  # be able to go back to old states and try again
end
