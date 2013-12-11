require 'forwardable'
require './lib/eloquiz'

class Quiz
  include ActiveModel::Validations
  extend Forwardable

  validates_presence_of :answer

  def_delegators :user, :application
  def_delegator :application, :quiz_complete?, :complete?
  def_delegators :current_question,
    :title, :setup, :rules, :prompt, :options, :slug, :fingerprint

  attr_reader :user, :current_question, :answer
  def initialize(user, question_slug = nil)
    @user = user
    if question_slug
      @current_question = application.quiz_question(question_slug.to_sym)
    else
      @current_question = application.next_quiz_question
    end
    generate
  end

  # Yeah, yeah.
  # The controller needs to talk to the quiz,
  # the view needs to talk to the question,
  # but really, we just want this one thing.
  def question
    self
  end

  def update_attributes(data)
    @answer = data[:answer] # for validations. It's kind of gross.
    statement = data[:options][answer]
    key = data[:fingerprint]

    result = Eloquiz::AnswerKey.correct?(statement, answer, key)
    application.quiz_result(question.slug, {result: result, answer: statement})
    if valid?
      application.save
    else
      false
    end
  end

  private

  def generate
    if application.quiz_questions.empty?
      application.quiz_questions = Eloquiz.random_questions.each {|q|
        # trigger the options so they get saved
        # and the user gets a consistent set in the view
        q.options
      }
      application.quiz_started_at = Time.now
      application.save
    end
  end
end
