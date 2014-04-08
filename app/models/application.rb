class Application < ActiveRecord::Base
  include OwnerSlug
  include Steps
  include QuizProgression

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

  def completed!
    update_attributes(status: 'completed')
  end

  def evaluating!
    update_attributes(status: 'evaluating')
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

  private

  def calculate_mean(evaluations)
    return 0 if evaluations.empty?
    total_points(evaluations) / evaluations.length
  end

  def total_points(evaluations)
    evaluations.reduce(0) { |sum, evaluation| sum += evaluation.total } 
  end
end