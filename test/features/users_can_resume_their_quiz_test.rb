require './test/test_helper'
require './test/helpers/feature.rb'

class UsersCanResumeTheirQuiz < MiniTest::Unit::TestCase
  include Test::Helpers::Feature

  def test_users_can_resume_their_quiz
    user = User.create! name: 'Richard Feynman', location: 'Los Alamos'
    set_current_user user

    # get user to the quiz
    user.apply!
    application = user.application
    application.completed_steps = Steps.all.map(&:to_s) # push them through to the quiz
    application.nuke_quiz!                              # reset all quiz info
    QuizQuestions.generate_for application

    # answer the first quiz question
    question  = application.quiz_questions.first
    statement = question.solution.statement # logic for finding the answer should probably be centralized somewhere
    application.quiz_result question.slug, result: true, answer: statement

    # when continuing, am sent to the quiz
    page.visit url_helpers.root_path
    page.click_on 'Continue Application'
    assert_equal url_helpers.quiz_question_path, page.current_path

    # on the 2nd question, since I already answered the first
    title_of_question_2 = application.quiz_questions[1].title
    assert page.body.include?(title_of_question_2)
  end
end
