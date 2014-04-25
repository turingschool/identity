require 'minitest/autorun'
require './lib/eloquiz/option'
require './lib/eloquiz/answer_key'

class EloquizAnswerKeyTest < Minitest::Test

  def test_answer_key
    a = Eloquiz::Option.new("I like chocolate.", false, 'A')
    b = Eloquiz::Option.new("I like strawberries.", true, 'B')
    key = Eloquiz::AnswerKey.generate([a, b])

    assert Eloquiz::AnswerKey.correct?("I like strawberries.", "B", key)
    refute Eloquiz::AnswerKey.correct?("I like strawberries.", "A", key)
    refute Eloquiz::AnswerKey.correct?("I like chocolate.", "A", key)
    refute Eloquiz::AnswerKey.correct?("I like chocolate.", "B", key)
  end
end

