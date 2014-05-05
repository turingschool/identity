class Application < ActiveRecord::Base
  include OwnerSlug
  include Steps
  include QuizProgression

  validates :status, inclusion: {
    in:      ApplicationStateMachine.valid_states,
    message: "%{value} is not a valid state, should be in #{ApplicationStateMachine.valid_states.inspect}"
  }

  belongs_to :user, inverse_of: :application
  has_many :evaluations, inverse_of: :application
  has_many :initial_evaluations, ->{ where(slug: 'initial_evaluation') }, class_name: 'Evaluation'
  has_many :interviews,          ->{ where(slug: 'interview') },          class_name: 'Evaluation'
  has_many :logic_evaluations,   ->{ where(slug: 'logic_evaluation') },   class_name: 'Evaluation'
  alias_method :owner, :user

  serialize :completed_steps, Array
  serialize :quiz_questions, Array
  serialize :quiz_answers, Hash
  mount_uploader :resume, ResumeUploader

  scope :upto, ->(step) do
    where('completed_steps LIKE ?', "%#{step}%").order("name asc")
  end

  scope :visible,                 -> { not_hidden_until_active.not_permahidden }
  scope :hidden_until_active,     -> { where hide_until_active: true  }
  scope :not_hidden_until_active, -> { where hide_until_active: false }
  scope :permahidden,             -> { where permahide:         true  }
  scope :not_permahidden,         -> { where permahide:         false }

  def self.steps
    Steps.all
  end

  def self.step_breakdown
    steps.each_with_object({}) do |step, counts|
      counts[step] = all_by_step(step).count
    end
  end

  def self.status_breakdown
    ApplicationStateMachine.valid_states.each_with_object({}) do |status, counts|
      counts[status] = where(status: status).count
    end
  end

  def self.all_by_step(step)
    all.joins(:user).order('name ASC').select do |application|
      application.current_step == step.to_s
    end
  end

  def nuke_quiz!
    self.quiz_questions = []
    self.quiz_answers = {}
    self.completed_steps = completed_steps - ['quiz', 'final']
    self.quiz_started_at = nil
    self.quiz_completed_at = nil
    self.save!
  end

  def quiz_started?
    quiz_started_at.present?
  end

  def complete?
    self.class.steps.all? { |step| completed?(step) }
  end

  def needs_initial_evaluation?
    status == 'needs_initial_evaluation_scores'
  end

  def needs_rejected_at_initial_evaluation_notification?
    status == 'needs_rejected_at_initial_evaluation_notification'
  end

  def needs_to_schedule_interview?
    status == 'needs_to_schedule_interview'
  end

  def needs_interview?
    status == 'needs_interview_scores'
  end

  def needs_rejected_at_interview_notification?
    status == 'needs_rejected_at_interview_notification'
  end

  def needs_logic_evaluation?
    status == 'needs_logic_evaluation_scores'
  end

  def needs_rejected_at_logic_evaluation_notification?
    status == 'needs_rejected_at_logic_evaluation_notification'
  end

  def needs_invitation?
    status == 'needs_invitation'
  end

  def needs_invitation_response?
    status == 'needs_invitation_response'
  end

  def evaluated_by?(user)
    initial_evaluations.where(user: user).any?
  end

  def interviewed_by?(user)
    interviews.where(user: user).any?
  end

  def evaluated_logic_by?(user)
    logic_evaluations.where(user: user).any?
  end

  def score
    initial_evaluation_score + interview_score + logic_evaluation_score
  end

  def initial_evaluation_score
    calculate_mean(initial_evaluations)
  end

  def initial_evaluation_scores
    initial_evaluations.collect(&:total)
  end

  def interview_score
    calculate_mean(interviews)
  end

  def interview_scores
    interviews.collect(&:total)
  end

  def logic_evaluation_score
    calculate_mean(logic_evaluations)
  end

  def logic_evaluation_scores
    logic_evaluations.collect(&:total)
  end

  def quiz_duration
    if quiz_complete?
      ((quiz_completed_at - quiz_started_at).to_f / 60).ceil
    end
  end

  private

  def calculate_mean(evaluations)
    return 0 if evaluations.empty?
    total_points(evaluations) / evaluations.length
  end

  def total_points(evaluations)
    evaluations.reduce(0) { |sum, evaluation| sum += evaluation.total }
  end
end
