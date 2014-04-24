require './test/test_helper'

class UpdateEvaluationTest < ActiveSupport::TestCase
  def test_munges_params_correctly
    alice = User.create(username: 'alice', is_admin: true)
    bob = User.create(username: 'bob')
    bob.apply!

    evaluation = InitialEvaluation.for(bob.application, by: alice)
    responses = evaluation.criteria.each_with_object({}) do |criterion, responses|
      responses[criterion.id.to_s] = {
        "score" => 2,
        "notes" => "notes for #{criterion.title}"
      }
    end

    UpdateEvaluation.call(evaluation, responses)
    evaluation.reload

    assert_equal [2], evaluation.criteria.map(&:score).uniq
    evaluation.criteria.each do |criterion|
      assert_match /notes for/, criterion.notes
    end
  end
end
