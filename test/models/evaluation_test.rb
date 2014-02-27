require './test/test_helper'

class EvaluationTest < ActiveSupport::TestCase
  def test_total
    alice = User.create(username: 'alice', is_admin: true)
    bob = User.create(username: 'bob')
    bob.apply!

    evaluation = InitialEvaluation.for(bob.application, by: alice)
    evaluation.criteria.each do |criterion|
      criterion.score = 3
    end
    evaluation.save
    assert_equal 18, evaluation.total
  end
end

