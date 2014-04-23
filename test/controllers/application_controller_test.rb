require './test/test_helper'

class ApplicationControllerTest < ActionController::TestCase
  class GettingCurrentUserUnhidesThemTest < ActionController::TestCase
    def self.controller_class
      ApplicationController
    end

    def test__sets_hide_until_active_to_false
      user        = User.create!
      application = user.apply!
      application.update_attribute :hide_until_active, true

      assert application.hide_until_active
      cookies[:user_id] = user.id
      @controller.current_user
      refute application.reload.hide_until_active
    end

    def test_does_not_blow_up_when_user_has_no_application
      user = User.create!
      @controller.session[:user_id] = user.id
      @controller.current_user
    end

    def test_does_not_blow_up_when_user_is_a_guest
      @controller.current_user
    end
  end
end
