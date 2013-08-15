class InitialEvaluation

  def self.for(application, by: user)
    evaluation = Evaluation.new(application: application, user: by, title: 'Initial Review')
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
      "Experience in a technical business / field",
      "Experience in a highly technical role",
      "Experience as a web developer or designer"
    ]
  end

  def curiosity
    Criterion.establish("Curiosity & Hard Work", curiosity_options)
  end

  def curiosity_options
    [
      "No evidence",
      "Some evidence of curiosity or hard work",
      "Demonstrates curiosity or experience with hard work",
      "Demonstrates significant intellectual curiosity and problem solving"
    ]
  end

  def communication
    Criterion.establish("Communication", communication_options)
  end

  def communication_options
    [
      "Boring or unclear",
      "Drifts in an out of clarity",
      "Able to communicate in a compelling manner",
      "Communicates excitement and intelligent ideas"
    ]
  end

  def independence
    Criterion.establish("Independence", independence_options)
  end

  def independence_options
    [
      "No evidence",
      "Wants to take initiative but doesn't seem to find time",
      "Some evidence of being a self-starter",
      "Strong evidence of being a self-starter",
    ]
  end

  def spirit
    Criterion.establish("Spirit & Passion", spirit_options)
  end

  def spirit_options
    [
      "Too awkward for me",
      "Positive but a bit awkward",
      "Compelling, but I would not want to share a desk",
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
