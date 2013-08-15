require './test/test_helper'

class CriterionTest < ActiveSupport::TestCase
  def test_establish_criterion
    options = ["idiot", "coherent", "bright", "genius"]
    criterion = Criterion.establish("intelligence", options)
    criterion.reload
    assert_equal "intelligence", criterion.title
    assert_equal options, criterion.options
  end

  def test_scale
    options = [
      "I cried",
      "I was bored",
      "I enjoyed it",
      "Best day EVAR"
    ]

    criterion = Criterion.establish("satisfaction", options)

    poor = Criterion::Option.new("I cried", 0, "Poor")
    fair = Criterion::Option.new("I was bored", 1, "Fair")
    good = Criterion::Option.new("I enjoyed it", 2, "Good")
    great = Criterion::Option.new("Best day EVAR", 3, "Great")

    expected = [great, good, fair, poor]
    assert_equal expected, criterion.scale
  end
end

