require './test/test_helper'

class Admin::ApplicantsControllerTest < ActionController::TestCase
  def test_can_hide_applicant
    user = User.create! is_admin: true
    @controller.login user
    application = user.apply!
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
end
