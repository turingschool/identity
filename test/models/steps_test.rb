require 'minitest/autorun'
require './app/models/steps'

class StepsTest < Minitest::Test

  Procedure = Struct.new(:completed_steps) do
    include Steps

    def save
      @saved = true
    end

    def saved?
      !!@saved
    end
  end

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

  def test_step_after_quiz
    process = Procedure.new(['bio', 'resume', 'essay', 'video', 'quiz'])
    assert_equal :final, process.next_step
  end

  def test_all_done
    process = Procedure.new(['bio', 'resume', 'essay', 'video', 'quiz', 'final'])
    assert process.done?
  end

  def test_not_done
    process = Procedure.new(['bio', 'resume', 'essay', 'video', 'quiz'])
    refute process.done?
  end

  def test_may_access_pre_step
    process = Procedure.new([])
    assert process.accessible?(:pre)
  end

  def test_may_access_completed_steps
    process = Procedure.new(['bio', 'resume', 'essay', 'video', 'quiz', 'final'])
    %i(bio resume essay video quiz).each do |step|
      assert process.accessible?(step)
    end
  end

  def test_may_access_next_step
    process = Procedure.new([])
    %i(bio resume essay video quiz final).each do |step|
      assert process.accessible?(step)
      process.complete step
    end
  end

  def test_may_not_access_future_steps
    process = Procedure.new([])
    %i(resume essay video quiz final).each do |step|
      refute process.accessible?(step)
    end
  end

  def test_it_knows_it_current_step
    process = Procedure.new(['bio', 'resume', 'essay'])
    assert_equal 'essay', process.current_step
  end
end
