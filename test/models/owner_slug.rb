require 'minitest/autorun'
require './app/models/owner_slug'

Toy = Struct.new(:owner) do
  include OwnerSlug
end

Kid = Struct.new(:name)

class OwnerSlugTest < Minitest::Test
  def test_slugify_single_name
    alice = Kid.new("Alice")
    assert_equal 'alice', Toy.new(alice).owner_slug
  end

  def test_slugify_common_form
    alice = Kid.new("Alice Smith")
    assert_equal 'alice-smith', Toy.new(alice).owner_slug
  end

  def test_slugify_middle_initial
    alice = Kid.new("Alice J. Smith")
    assert_equal 'alice-j-smith', Toy.new(alice).owner_slug
  end

  def test_slugify_apostrophes
    alice = Kid.new("Alice O'Toole")
    assert_equal 'alice-otoole', Toy.new(alice).owner_slug
  end

  def test_slugify_suffixes
    alice = Kid.new("Alice Smith, Ph.D.")
    assert_equal 'alice-smith-phd', Toy.new(alice).owner_slug
  end
end
