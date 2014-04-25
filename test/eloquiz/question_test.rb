gem 'minitest', '~> 5.1'
require 'minitest/autorun'
require 'active_support'
require 'active_support/core_ext/string/inflections'

require './lib/eloquiz/option'
require './lib/eloquiz/question'

class EloquizQuestionTest < Minitest::Test
  class Fake < Eloquiz::Question
  end

  class FakeQuestion < Eloquiz::Question
  end

  def question_with_options(&block)
    a = Eloquiz::Option.new("I like chocolate.",       false)
    b = Eloquiz::Option.new("Programming is awesome.", true)
    c = Eloquiz::Option.new("Cake is delicious.",      false)
    d = Eloquiz::Option.new("Jellybeans are healthy.", false)
    e = Eloquiz::Option.new("Trees walk south.",       false)

    question = Eloquiz::Question.new
    question.stub(:random_options, [a, b, c, d, e]) { block.call question }
  end

  def test_choices
    question_with_options do |question|
      expected = %w(A B C D E)
      assert_equal expected, question.options.map(&:choice)
    end
  end

  def test_solution
    question_with_options do |question|
      assert question.solution.answer
    end
  end

  def test_slug
    assert_equal :fake_question, FakeQuestion.new.slug
    assert_equal :fake, Fake.new.slug
  end

  def test_title
    assert_equal "Fake Question", FakeQuestion.new.title
    assert_equal "Fake", Fake.new.title
  end
end

