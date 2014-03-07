require 'forwardable'

class CompletedQuiz
  class Problem
    extend Forwardable

    attr_reader :question, :choice

    def_delegators :question,
                   :title, :setup, :rules

    def initialize(question, choice)
      @question = question
      @choice = choice
    end

    def correct?
      choice[:result]
    end

    def answer
      choice[:answer]
    end

    def correct_answer
      question.options.find(&:answer?).statement
    end
  end

  attr_reader :questions, :answers
  def initialize(questions, answers)
    @questions = questions
    @answers = answers
  end

  def problems
    @problems ||= questions.map {|question|
      Problem.new(question, answers[question.slug])
    }
  end
end
