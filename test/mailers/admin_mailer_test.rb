require 'test_helper'

class AdminMailerTest < ActionMailer::TestCase
  def setup
    @admin = User.create(name: "Jorge", email: "jorge@example.com", is_admin: true)
    @user  = User.create(name: "Alice", email: "alice@example.com")

    Application.create(user_id: @user.id)
  end

  test "application_submitted" do
    AdminMailer.application_submitted(@user).deliver
    result = ActionMailer::Base.deliveries.last

    assert result
    assert_equal [@admin.email], result.to
    assert_equal ["contact@turing.io"], result.from
    assert_equal "Alice submitted an Application", result.subject
  end
end