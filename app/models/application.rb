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
  has_many :initial_evaluations, ->{ where(slug: 'triage') },    class_name: 'Evaluation'
  has_many :interview_notes,     ->{ where(slug: 'selection') }, class_name: 'Evaluation'
  has_many :logic_evaluations,   ->{ where(slug: 'logic') },     class_name: 'Evaluation'
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

  def self.breakdown
    steps.each_with_object({}) do |step, counts|
      counts[step] = upto(step).count
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
    self.class.steps.all? {|step| completed?(step)}
  end

  def evaluated_by?(user)
    evaluations.where(user: user).any?
  end

  def interviewed_by?(user)
    interview_notes.where(user: user).any?
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

  def interview_score
    calculate_mean(interview_notes)
  end

  def logic_evaluation_score
    calculate_mean(logic_evaluations)
  end

  def quiz_duration
    if quiz_complete?
      ((quiz_completed_at - quiz_started_at).to_f / 60).ceil
    end
  end

  def submitted!
    state_machine = ApplicationStateMachine.new status
    update_attributes(status: state_machine.submitted!)
  end

  # FIXME: This will need to change
  def evaluating!
    state_machine = ApplicationStateMachine.new status
    update_attributes(status: 'evaluating')
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
