class Evaluation < ActiveRecord::Base
  has_many :criteria
  belongs_to :user
  belongs_to :application

  def applicant
    application.user
  end

  def applicant_name
    application.user.name
  end

  def evaluator
    user
  end

  def evaluator_name
    user.name
  end

  def has_notes?
    criteria.any? {|criterion| criterion.has_notes?}
  end

  def total
    criteria.map(&:score).compact.sum
  end
end