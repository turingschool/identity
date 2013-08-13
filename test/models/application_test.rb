require './test/test_helper'

class ApplicationTest < ActiveSupport::TestCase
  def test_serializes_application_steps
    app = Application.create(completed_steps: %w(one two))
    app.reload
    assert_equal %w(one two), app.completed_steps
  end
end
