require 'minitest/autorun'
require 'minitest/pride'
require './app/models/quiz_progression'

module Eloquiz
  class FakeQuizQuestion
    attr_reader :slug
    def initialize(slug)
      @slug = slug
    end

    def self.generate
      :generated
    end
  end
end

class QuizProgressionTest < MiniTest::Unit::TestCase

  Challenge = Struct.new(:quiz_questions, :quiz_answers) do
    include QuizProgression
  end

  def q(slug)
    Eloquiz::FakeQuizQuestion.new(slug)
  end

  def test_quiz_generated_p
    refute Challenge.new([], {}).quiz_generated?
    assert Challenge.new([q(:one)], {}).quiz_generated?
  end

  def test_first_quiz_question
    challenge = Challenge.new([q(:one), q(:two)], {})
    assert_equal :one, challenge.next_quiz_question.slug
  end

  def test_next_quiz_question
    challenge = Challenge.new([q(:one), q(:two)], {one: true})
    assert_equal :two, challenge.next_quiz_question.slug
  end

  def test_incomplete_quiz
    challenge = Challenge.new([q(:one), q(:two)], {one: true})
    refute challenge.quiz_complete?
  end

  def test_completed_quiz
    challenge = Challenge.new([q(:one)], {one: true})
    assert challenge.quiz_complete?
  end

  def test_quiz_score
    challenge = Challenge.new([q(:one), q(:two), q(:three)], {one: true, two: false, three: false})
    assert_equal 1, challenge.quiz_score
  end

  def test_higher_quiz_score
    challenge = Challenge.new([q(:one), q(:two), q(:three)], {one: true, two: false, three: true})
    assert_equal 2, challenge.quiz_score
  end

  def test_quiz_size
    challenge = Challenge.new([q(:one), q(:two), q(:three)], {})
    assert_equal 3, challenge.quiz_size
  end

  def test_answer_a_question
    challenge = Challenge.new([q(:one)], {})
    challenge.quiz_result(:one, true)
    expected = {one: true}
    assert_equal expected, challenge.quiz_answers
  end

  # Fail silently. This will only happen if someone
  # messes with the form, so it's fine if they're confused
  def test_ignore_answers_to_the_wrong_question
    challenge = Challenge.new([q(:one), q(:two)], {})
    challenge.quiz_result(:two, true)
    expected = {}
    assert_equal expected, challenge.quiz_answers
  end

  # As above.
  def test_ignore_answers_to_nonexistent_questions
    challenge = Challenge.new([q(:one), q(:two)], {})
    challenge.quiz_result(:three, true)
    expected = {}
    assert_equal expected, challenge.quiz_answers
  end
end

