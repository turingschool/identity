class InterviewEvaluation

  def self.for(application, by: user)
    evaluation = Evaluation.new(application: application, user: by, title: 'Interview Notes', slug: 'selection')
    new(evaluation).generate
  end

  attr_reader :evaluation
  def initialize(evaluation)
    @evaluation = evaluation
  end

  def generate
    evaluation.criteria << grit
    evaluation.criteria << collaboration
    evaluation.criteria << demonstration
    evaluation.criteria << curiosity
    evaluation.criteria << communication
    evaluation.criteria << commitment
    evaluation.criteria << spirit
    evaluation.criteria << overall
    evaluation.save
    evaluation
  end

  private

  def grit
    Criterion.establish("Grit", grit_options)
  end

  def grit_options
    [
      "Evidence of giving up easily",
      "Awareness that they want to improve their stick-to-it-ness",
      "Evidence that they follow through on their commitments",
      "Demonstrates grit in the face of extraordinary circumstances",
    ]
  end

  def collaboration
    Criterion.establish("Collaboration", collaboration_options)
  end

  def collaboration_options
    [
      "Directly expresses hesitation around collaboration",
      "Will participate in collaboration but doesn't seek it out",
      "Collaborates with a balance of expertise and humility",
      "Acts as a catalyst for the people around them",
    ]
  end

  def demonstration
    Criterion.establish("Demonstrated Interest", demonstration_options)
  end

  def demonstration_options
    [
      "No concrete evidence",
      "Some small effort (e.g. Railsbridge or user group)",
      "Some organized learning (treehouse, codecademy, book)",
      "Built a project of any scope",
      "Worked as a developer"
    ]
  end

  def curiosity
    Criterion.establish("Are they doers?", curiosity_options)
  end

  def curiosity_options
    [
      "No evidence",
      "Expresses clear interests without much follow-through",
      "Putting effort towards achievements",
      "Follows through in turning interests into achievements"
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

  def commitment
    Criterion.establish("Commitment", commitment_options)
  end

  def commitment_options
    [
      "Evidence of non-commitment (avoiding or breaking commitments)",
      "They feel bad about breaking commitments",
      "Finishes what they start",
      "Stick with commitment through transitions"
    ]
  end

  def spirit
    Criterion.establish("Likability", spirit_options)
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
