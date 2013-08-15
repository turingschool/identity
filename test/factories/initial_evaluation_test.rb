require './test/test_helper'

class InitialEvaluationTest < ActiveSupport::TestCase
  def test_generate
    alice = User.create(username: 'alice', is_admin: true)
    bob = User.create(username: 'bob')
    bob.apply!

    evaluation = InitialEvaluation.for(bob.application, by: alice)
    assert_equal 6, evaluation.reload.criteria.count
    assert_equal 'Initial Review', evaluation.title
  end
end

