require 'minitest/autorun'
require './app/models/quiz_progression'

module Eloquiz
  class FakeQuizQuestion
    def self.generate
      :generated
    end
  end
end

class QuizProgressionTest < MiniTest::Unit::TestCase

  Challenge = Struct.new(:quiz_questions, :quiz_answers) do
    include QuizProgression
  end

  def test_quiz_generated_p
    refute Challenge.new([], {}).quiz_generated?
    assert Challenge.new([:one], {}).quiz_generated?
  end

  def test_first_quiz_slug
    challenge = Challenge.new([:one, :two, :three], {})
    assert_equal :one, challenge.next_quiz_slug
  end

  def test_next_quiz_slug
    challenge = Challenge.new([:one, :two, :three], {one: true})
    assert_equal :two, challenge.next_quiz_slug
  end

  def test_first_quiz_question_number
    challenge = Challenge.new([:one, :two, :three], {})
    assert_equal 1, challenge.next_quiz_question_number
  end

  def test_next_quiz_question_number
    challenge = Challenge.new([:one, :two, :three], {one: true})
    assert_equal 2, challenge.next_quiz_question_number
  end

  def test_quiz_score
    challenge = Challenge.new([:one, :two, :three], {one: true, two: false, three: false})
    assert_equal 1, challenge.quiz_score
  end

  def test_quiz_size
    challenge = Challenge.new([:one, :two, :three], {})
    assert_equal 3, challenge.quiz_size
  end

  def test_answer_a_question
    challenge = Challenge.new([:one, :two, :three], {})
    challenge.quiz_result(:one, true)
    expected = {one: true}
    assert_equal expected, challenge.quiz_answers
  end

  # Fail silently. This will only happen if someone
  # messes with the form, so it's fine if they're confused
  def test_ignore_answers_to_the_wrong_question
    challenge = Challenge.new([:one, :two, :three], {})
    challenge.quiz_result(:two, true)
    expected = {}
    assert_equal expected, challenge.quiz_answers
  end

  # As above.
  def test_ignore_answers_to_nonexistent_questions
    challenge = Challenge.new([:one, :two, :three], {})
    challenge.quiz_result(:four, true)
    expected = {}
    assert_equal expected, challenge.quiz_answers
  end
end

