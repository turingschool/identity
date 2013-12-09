require 'forwardable'
require './lib/eloquiz'

class QuizQuestion
  include ActiveModel::Validations
  extend Forwardable

  validates_presence_of :answer

  def_delegators :question, :title, :setup, :rules, :prompt, :options, :slug, :fingerprint
  def_delegators :user, :application

  attr_reader :user, :question_slug, :answer
  def initialize(user, question_slug = nil)
    @user = user
    @question_slug = question_slug
  end

  def question
    @question ||= next_question
  end

  def update_attributes(data)
    @answer = data[:answer] # for validations. It's kind of gross.
    statement = data[:options][answer]
    key = data[:fingerprint]

    result = Eloquiz::AnswerKey.correct?(statement, answer, key)
    application.quiz_result(question.slug, false)
    if valid?
      application.save
    else
      false
    end
  end

  def next_question
    if application.quiz_questions.empty?
      application.quiz_questions = Eloquiz.random_questions
      application.save
    end
    application.next_quiz_question
  end
end
