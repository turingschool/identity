class Summary
  Breakdown = Struct.new(:title, :scores) do
    def average
      score / count
    end

    def score
      scores.inject(:+).to_f
    end

    def count
      scores.size.to_f
    end
  end

  attr_reader :evaluations, :variance_threshold, :review_count_threshold

  def initialize(evaluations, thresholds = {})
    @evaluations = evaluations
    @variance_threshold = thresholds.fetch(:variance) { 2 }
    @review_count_threshold = thresholds.fetch(:review_count) { 2 }
  end

  def meets_thresholds?
    enough_reviews? && low_enough_variance?
  end

  def enough_reviews?
    count >= review_count_threshold
  end

  def low_enough_variance?
    variance <= variance_threshold
  end

  def average
    score / count
  end

  def score
    evaluations.map(&:total).inject(:+).to_f
  end

  def count
    evaluations.size.to_f
  end

  def variance_of(evaluation)
    (evaluation.total - average).abs
  end

  def variance
    total_variance / count
  end

  def total_variance
    evaluations.map {|evaluation| variance_of(evaluation)}.inject(:+).to_f
  end

  def breakdown
    histogram = Hash.new {|histogram, title|
      histogram[title] = Breakdown.new(title, [])
    }
    evaluations.each do |evaluation|
      evaluation.criteria.each do |criterion|
        histogram[criterion.title].scores << criterion.score
      end
    end
    histogram.values
  end
end
