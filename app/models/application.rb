class Application < ActiveRecord::Base
  include OwnerSlug
  include Steps
  include QuizProgression

  belongs_to :user, inverse_of: :application
  has_many :evaluations, inverse_of: :application
  alias_method :owner, :user

  serialize :completed_steps, Array
  serialize :quiz_questions, Array
  serialize :quiz_answers, Hash
  mount_uploader :resume, ResumeUploader

  scope :upto, ->(step) do
    where('completed_steps LIKE ?', "%#{step}%").joins(:user).order("name asc")
  end

  def self.steps
    Steps.all
  end

  def self.breakdown
    steps.each_with_object({}) do |step, counts|
      counts[step] = upto(step).count
    end
  end

  def nuke_quiz!
    self.quiz_questions = []
    self.quiz_answers = []
    self.completed_steps = completed_steps - [:quiz]
    self.quiz_started_at = nil
    self.quiz_completed_at = nil
    self.save!
  end

  def complete?
    self.class.steps.all? {|step| completed?(step)}
  end

  def evaluated_by?(user)
    evaluations.where(user: user).any?
  end
end

