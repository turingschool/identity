class Application < ActiveRecord::Base
  include OwnerSlug
  include Steps

  belongs_to :user, inverse_of: :application
  has_many :evaluations, inverse_of: :application
  alias_method :owner, :user

  serialize :completed_steps, Array
  # It is NOT validating the file type. What the heck?
  mount_uploader :resume, ResumeUploader

  scope :upto, ->(step) do
    steps = Steps.all[0..Steps.all.index(step.to_sym)].map(&:to_s).to_yaml
    where(completed_steps: steps)
  end

  def self.steps
    Steps.all
  end

  def self.breakdown
    steps.each_with_object({}) do |step, counts|
      counts[step] = upto(step).count
    end
  end

  def evaluated_by?(user)
    evaluations.where(user: user).any?
  end
end

