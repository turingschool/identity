require './test/test_helper'

class EvaluationTest < ActiveSupport::TestCase
  attr_reader :evaluation,
              :evaluator,
              :applicant

  def setup
    @evaluator = User.create(username: 'alice', name: 'Alice', is_admin: true)
    @applicant = User.create(username: 'bob', name: 'Bob')
    applicant.apply!

    @evaluation = InitialEvaluation.for(applicant.application, by: evaluator)
  end

  test 'it has an applicant' do
    assert_equal applicant, evaluation.applicant
  end

  test 'it has an applicant name' do
    assert_equal 'Bob', evaluation.applicant_name
  end

  test 'it has an evaluator' do
    assert_equal evaluator, evaluation.evaluator
  end

  test 'it has an evaluator name' do
    assert_equal 'Alice', evaluation.evaluator_name
  end

  test 'it knows it has notes' do
    # When it doesn't have notes
    refute evaluation.has_notes?

    # When it has a criterion with notes
    evaluation.criteria.first.notes = 'Lorem Ipsum'
    evaluation.save
    assert evaluation.has_notes?
  end

  test 'it returns its total points' do
    evaluation.criteria.each do |criterion|
      criterion.score = 3
    end

    evaluation.save
    assert_equal 18, evaluation.total
  end
end