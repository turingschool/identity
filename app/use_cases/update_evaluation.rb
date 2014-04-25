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
      criterion.save
    end
    evaluation.completed_at = Time.now
    evaluation.save
  end

  def self.call(evaluation, responses)
    new(evaluation, responses).save
  end
end
