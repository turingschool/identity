class UpdateEvaluation
  attr_reader :evaluation, :responses
  def initialize(evaluation, responses)
    @evaluation = evaluation
    @responses = responses
  end

  def save
    evaluation.criteria.each do |criterion|
      values = responses[criterion.id.to_s]
      criterion.score = values["score"]
      criterion.notes = values["notes"]
    end
    evaluation.save
  end
end
