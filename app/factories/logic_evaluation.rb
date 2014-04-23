class LogicEvaluation

  def self.for(application, by: user)
    evaluation = Evaluation.new(application: application, user: by, title: 'Logic Evaluation', slug: 'logic_evaluation')
    new(evaluation).generate
  end

  attr_reader :evaluation
  def initialize(evaluation)
    @evaluation = evaluation
  end

  def generate
    evaluation.criteria << answers
    evaluation.criteria << problem_solving
    evaluation.criteria << communication
    evaluation.criteria << fortitude
    evaluation.save
    evaluation
  end

  private

  def answers
    Criterion.establish("Answers", answers_options)
  end

  def answers_options
    [
      "Missed more than two",
      "Missed two",
      "Missed one",
      "All correct",
    ]
  end

  def problem_solving
    Criterion.establish("Problem Solving Process", problem_solving_options)
  end

  def problem_solving_options
    [
      "Can't even get it with help",
      "Needs the same reminders multiple times",
      "Needs to be told what's wrong, but then they can correct it",
      "Executes a co-developed strategy",
      "Plans and executes a coherent strategy independently",
    ]
  end

  def communication
    Criterion.establish("Communication", communication_options)
  end

  def communication_options
    [
      "It's like pulling teeth",
      "Narrates their process, but it's not an interaction",
      "Communicates well when stuck, narrates when they're OK",
      "Shares plans before they begin and communicates along the way",
      "Creates a comfortable, clear channel of communication",
    ]
  end

  def fortitude
    Criterion.establish("Fortitude", fortitude_options)
  end

  def fortitude_options
    [
      "Needs direct encouragement to keep going",
      "Keeps going but whines",
      "You can tell they're frustrated, but they know how to handle it",
      "Displays a calm determination and enjoys the challenge"
    ]
  end
end
