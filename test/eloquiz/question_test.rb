require 'minitest/autorun'
require './lib/eloquiz/option'
require './lib/eloquiz/question'

class EloquizQuestionTest < MiniTest::Unit::TestCase

  def test_choices
    a = Eloquiz::Option.new("I like chocolate.", false)
    b = Eloquiz::Option.new("Programming is awesome.", true)
    c = Eloquiz::Option.new("Cake is delicious.", false)
    d = Eloquiz::Option.new("Jellybeans are healthy.", false)
    e = Eloquiz::Option.new("Trees walk south.", false)

    question = Eloquiz::Question.new
    question.stub(:random_options, [a, b, c, d, e]) do
      expected = %w(A B C D E)
      assert_equal expected, question.options.map(&:choice)
    end
  end
end

