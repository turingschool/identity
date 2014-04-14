require './test/test_helper'
require 'helpers/feature' # rename helpers to support?
require 'support/factory'

class Admin::ApplicationFlowTest < MiniTest::Unit::TestCase
  include Test::Helpers::Feature

  def setup
    super
    Capybara.current_driver = Capybara.javascript_driver
  end

  def admin1
    @admin1 ||= Factory::User.create_user name: 'admin1', is_admin: true
  end

  def admin2
    @admin2 ||= User.create_user name: 'admin2', is_admin: true
  end

  def user
    @user ||= Factory::User.create_user name: 'user1' do |user|
      application        = user.apply
      application.status = 'needs_interview_scores'
      Factory::Apply.complete application
    end
  end

  def complete_evaluation(admin, user, evaluation_button_name, evaluation_title, max_or_min_points)
    set_current_user admin
    result = page.visit url_helpers.admin_applicant_path(user)
    page.click_on evaluation_button_name
    assert page.has_content?(evaluation_title)
  end

  def test_happy_path
    complete_evaluation admin1, user, 'Create Evaluation', 'Initial Review', 'Initial Review'
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
