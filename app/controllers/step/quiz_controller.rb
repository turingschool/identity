class Step::QuizController < StepController

  def show
    if current_user.application.quiz_started?
      redirect_to quiz_question_path
    end
  end

  private

  def current_step
    :quiz
  end
end