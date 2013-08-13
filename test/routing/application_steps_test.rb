require './test/test_helper'

class ApplicationStepsTest < ActionController::TestCase

  def test_step_one
    options = {
      controller: 'steps/bio', action: 'show'
    }
    assert_recognizes(options, '/apply/step-1')
  end
end
