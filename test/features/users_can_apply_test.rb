# encoding: utf-8

require './test/test_helper'


class UsersCanApplyTest < MiniTest::Unit::TestCase
  def page
    @page ||=  begin
      Capybara.app = Rails.application
      Capybara.current_session
    end
  end

  def save_and_open_page
    `open #{page.save_page}`
  end

  def path_to(fixture_file)
    File.join ActionController::TestCase.fixture_path, fixture_file
  end

  def test_users_can_apply_via_the_interwebz
    alice = User.create! name:     'Alice Smith',
                         location: 'New York, NY'
    $current_user = alice

    # start application
    page.visit '/'
    page.click_button 'Start Application'

    # bio
    page.fill_in 'email', with: 'alice@example.com'
    page.click_button 'Submit Information'
    application = alice.reload.application
    assert_equal 'alice@example.com', alice.email
    assert_equal ['bio'], application.completed_steps

    # résumé
    page.attach_file :resume_file, path_to('hello.pdf')
    page.click_button 'Upload'
    assert_equal File.read(path_to('hello.pdf')).force_encoding('ASCII-8BIT'),
                 application.resume.read.force_encoding('ASCII-8BIT')
    assert_equal ["bio", "resume"], application.completed_steps

    # essay
    page.fill_in 'essay_url', with: 'https://gist.github.com/kytrinyx/12345'
    page.click_button 'Save'
    assert_equal 'https://gist.github.com/kytrinyx/12345', application.reload.essay_url
    assert_equal ["bio", "resume", "essay"], application.completed_steps

    # video
    page.fill_in 'video_url', with: 'https://www.youtube.com/watch?v=fCKM2SU-8Rw'
    page.click_button 'Save'
    assert_equal "https://www.youtube.com/watch?v=fCKM2SU-8Rw", application.reload.video_url
    assert_equal ["bio", "resume", "essay", "video"], application.completed_steps

    # quiz
    num_questions = Eloquiz.random_questions.size
    page.click_link 'Start Now'

    num_questions.times do |i|
      page.choose 'quiz_answer_A'
      page.click_button 'Submit'
    end

    application.reload
    assert_equal num_questions, application.quiz_questions.size
    assert_equal num_questions, application.quiz_answers.size
    application.quiz_questions.zip(application.quiz_answers).each do |question, (name, answer)|
      expected_answer = question.options.first.statement
      actual_answer   = answer[:answer]
      assert_equal expected_answer, actual_answer
    end

    assert_equal ["bio", "resume", "essay", "video", "quiz"], application.completed_steps

    # final
    page.click_on 'Continue Application'
    page.click_on 'Submit Application'
    root_path = Rails.application.routes.url_helpers.root_path
    assert_equal root_path, page.current_path
    assert_equal ["bio", "resume", "essay", "video", "quiz", "final"], application.completed_steps
  end
end
