require './test/test_helper'

class Admin::ApplicantsControllerTest < ActionController::TestCase
  include Test::Helpers::Feature

  def setup
    set_current_user User.new is_admin: true
  end

  def test_can_hide_applicant
    user = User.create! is_admin: true, &:build_application
    @controller.login user
    application = user.application
    refute application.permahide
    refute application.hide_until_active

    # hide em
    patch :update, id: user.id, user: { permahide: true, hide_until_active: true }
    application.reload
    assert application.permahide
    assert application.hide_until_active

    # reveal em
    patch :update, id: user.id, user: { permahide: false, hide_until_active: false }
    application.reload
    refute application.permahide
    refute application.hide_until_active
  end

  def test_in_status_renders_the_users_in_that_status
    @controller.login User.new is_admin: true
    user1 = User.create! name: 'Angelina', &:build_application
    user2 = User.create! name: 'Bobarino' do |bob|
      bob.build_application status: 'needs_initial_evaluation_scores'
    end

    refute_equal user1.application.status,
                 user2.application.status

    get :in_status, status_name: user1.application.status
    assert_includes response.body, user1.name
    refute_includes response.body, user2.name

    get :in_status, status_name: user2.application.status
    assert_includes response.body, user2.name
    refute_includes response.body, user1.name
  end
end
