require 'minitest/autorun'
require './app/models/steps'

Procedure = Struct.new(:completed_steps) do
  include Steps

  def save
    @saved = true
  end

  def saved?
    !!@saved
  end
end

class StepsTest < MiniTest::Unit::TestCase
  def test_completed_ey
    process = Procedure.new(['chew'])
    assert process.completed?(:chew)
    refute process.completed?(:swallow)
  end

  def test_complete
    process = Procedure.new([])
    process.complete :chew
    assert process.completed? :chew
  end

  def test_complete_without_duplicates
    process = Procedure.new([])
    process.complete :chew
    assert process.completed? :chew
  end

  def test_complete_does_not_save
    process = Procedure.new([])
    process.complete :chew
    refute process.saved?
  end

  def test_complete_bang_saves
    process = Procedure.new([])
    process.complete! :chew
    assert process.saved?
  end

  def test_first_step
    process = Procedure.new([])
    assert_equal :bio, process.next_step
  end

  def test_step_after_bio
    process = Procedure.new(['bio'])
    assert_equal :resume, process.next_step
  end

  def test_step_after_resume
    process = Procedure.new(['bio', 'resume'])
    assert_equal :essay, process.next_step
  end

  def test_step_after_essay
    process = Procedure.new(['bio', 'resume', 'essay'])
    assert_equal :video, process.next_step
  end

  def test_step_after_video
    process = Procedure.new(['bio', 'resume', 'essay', 'video'])
    assert_equal :quiz, process.next_step
  end

  def test_all_done
    process = Procedure.new(['bio', 'resume', 'essay', 'video', 'quiz'])
    assert process.done?
  end

  def test_not_done
    process = Procedure.new(['bio', 'resume', 'essay', 'video'])
    refute process.done?
  end
end

