require './test/test_helper'

class EvaluationTest < ActiveSupport::TestCase
  def test_total
    alice = User.create(username: 'alice', is_admin: true, email: "alice@example.com")
    bob = User.create(username: 'bob', email: "bob@example.com")
    bob.apply!

    evaluation = InitialEvaluation.for(bob.application, by: alice)
    evaluation.criteria.each do |criterion|
      criterion.score = 3
    end
    evaluation.save
    assert_equal 18, evaluation.total
  end
end

