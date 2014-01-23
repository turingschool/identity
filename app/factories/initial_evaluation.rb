class InitialEvaluation

  def self.for(application, by: user)
    evaluation = Evaluation.new(application: application, user: by, title: 'Initial Review', slug: 'triage')
    new(evaluation).generate
  end

  attr_reader :evaluation
  def initialize(evaluation)
    @evaluation = evaluation
  end

  def generate
    evaluation.criteria << background
    evaluation.criteria << curiosity
    evaluation.criteria << communication
    evaluation.criteria << independence
    evaluation.criteria << spirit
    evaluation.criteria << overall
    evaluation.save
    evaluation
  end

  private

  def background
    Criterion.establish("Experience & Background", background_options)
  end

  def background_options
    [
      "No evidence",
      "Experience in a technical business / field (ex: worked in a startup)",
      "Experience in a highly technical role (ex: Q/A)",
      "Experience as a web developer or designer"
    ]
  end

  def curiosity
    Criterion.establish("Curiosity & Hard Work", curiosity_options)
  end

  def curiosity_options
    [
      "No evidence",
      "Some evidence of curiosity or hard work (ex: hobbyist programming)",
      "Demonstrates curiosity or experience with hard work (ex: independent learning/projects)",
      "Demonstrates significant intellectual curiosity and problem solving (ex: several executed/completed independent projects)"
    ]
  end

  def communication
    Criterion.establish("Communication", communication_options)
  end

  def communication_options
    [
      "Boring, unclear, or strange",
      "Able to communicate in a compelling style, but not enough substance",
      "Clear communication of concrete ideas",
      "Communicates excitement and intelligent ideas"
    ]
  end

  def independence
    Criterion.establish("Independence", independence_options)
  end

  def independence_options
    [
      "No evidence",
      "Wants to take initiative but doesn't make it happen",
      "Some evidence of being a self-starter",
      "Strong evidence of being a self-starter",
    ]
  end

  def spirit
    Criterion.establish("Spirit & Passion", spirit_options)
  end

  def spirit_options
    [
      "I would dislike working with them",
      "Has their quirks, but I wouldn't mind working with them",
      "I think they'd be cool",
      "Someone I would want to work with everyday"
    ]
  end

  def overall
    Criterion.establish("Overall", overall_options)
  end

  def overall_options
    [
      "Definite no",
      "Could be good",
      "Recommended",
      "Must-have"
    ]
  end
end
