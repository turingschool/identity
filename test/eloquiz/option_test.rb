require 'minitest/autorun'
require './lib/eloquiz/option'

class EloquizOptionTest < Minitest::Test
  def test_option
    option = Eloquiz::Option.new("I like chocolate.", false)
    refute option.answer?

    option = Eloquiz::Option.new("I like strawberries.", true)
    assert option.answer?
  end
end
