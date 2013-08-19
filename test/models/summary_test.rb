require 'minitest/autorun'
require './app/models/summary'
class SummaryTest < Minitest::Unit::TestCase

  FakeEvaluation = Struct.new(:criteria) do
    def total
      criteria.map(&:score).inject(:+)
    end
  end

  FakeCriterion = Struct.new(:score, :title)

  def test_evaluation_summary
    criteria = [
      FakeCriterion.new(1, 'brain'),
      FakeCriterion.new(2, 'brawn'),
      FakeCriterion.new(3, 'whimsy')
    ]
    alice = FakeEvaluation.new(criteria)
    assert_equal 6, alice.total

    criteria = [
      FakeCriterion.new(2, 'brain'),
      FakeCriterion.new(2, 'brawn'),
      FakeCriterion.new(3, 'whimsy')
    ]
    bob = FakeEvaluation.new(criteria)
    assert_equal 7, bob.total

    criteria = [
      FakeCriterion.new(1, 'brain'),
      FakeCriterion.new(1, 'brawn'),
      FakeCriterion.new(3, 'whimsy')
    ]
    charlie = FakeEvaluation.new(criteria)
    assert_equal 5, charlie.total

    summary = Summary.new([alice, bob, charlie])
    assert_in_delta 6.0, summary.average, 0.01
    assert_in_delta 3, summary.count, 0.01

    s1, s2, s3 = summary.breakdown
    assert_equal 'brain', s1.title
    assert_in_delta 4, s1.score, 0.01
    assert_in_delta 1.34, s1.average, 0.01

    assert_equal 'brawn', s2.title
    assert_in_delta 5.0, s2.score, 0.01
    assert_in_delta 1.67, s2.average, 0.01

    assert_equal 'whimsy', s3.title
    assert_in_delta 9.0, s3.score
    assert_in_delta 3.0, s3.average

    assert_in_delta 0.0, summary.variance_of(alice), 0.01
    assert_in_delta 1.0, summary.variance_of(bob), 0.01
    assert_in_delta 1.0, summary.variance_of(charlie), 0.01

    assert_in_delta 0.67, summary.variance, 0.01

    assert summary.meets_thresholds?
  end

  def test_single_evaluation_does_not_meet_thresholds
    criteria = [
      FakeCriterion.new(1, 'brain'),
      FakeCriterion.new(2, 'brawn'),
      FakeCriterion.new(3, 'whimsy')
    ]
    alice = FakeEvaluation.new(criteria)
    summary = Summary.new([alice])
    refute summary.meets_thresholds?
  end

  def test_wildly_differing_evaluations_do_not_meet_thresholds
    criteria = [
      FakeCriterion.new(3, 'brain'),
      FakeCriterion.new(3, 'brawn'),
      FakeCriterion.new(3, 'whimsy')
    ]
    alice = FakeEvaluation.new(criteria)

    criteria = [
      FakeCriterion.new(1, 'brain'),
      FakeCriterion.new(1, 'brawn'),
      FakeCriterion.new(1, 'whimsy')
    ]
    bob = FakeEvaluation.new(criteria)

    summary = Summary.new([alice, bob])
    refute summary.meets_thresholds?
  end
end

