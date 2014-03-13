require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  def setup
    @user  = User.create(name: "Alice", email: "alice@example.com")
  end

  def email
    ActionMailer::Base.deliveries.last
  end

  test "welcome" do
    UserMailer.welcome(@user).deliver

    assert email
    assert_equal [@user.email], email.to
    assert_equal ["contact@turing.io"], email.from
    assert_equal "Welcome to your Turing Application", email.subject
  end

  test "quiz" do
    UserMailer.quiz(@user).deliver

    assert email
    assert_equal [@user.email], email.to
    assert_equal ["contact@turing.io"], email.from
    assert_equal "Prepare for the Logic Quiz", email.subject
  end

  test "final" do
    UserMailer.final(@user).deliver

    assert email
    assert_equal [@user.email], email.to
    assert_equal ["contact@turing.io"], email.from
    assert_equal "Your Turing Application is Complete", email.subject
  end
end