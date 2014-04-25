require './test/test_helper'

class Admin::DashboardControllerTest < ActionController::TestCase
  include Test::Helpers::Feature

  def setup
    set_current_user User.new is_admin: true
  end

  def test_index_renders_links_to_the_states
    get :index
    ApplicationStateMachine.valid_states.each do |state_name|
      assert_includes response.body, state_name
    end
  end
end
