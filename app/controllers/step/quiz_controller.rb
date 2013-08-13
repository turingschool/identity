class Step::QuizController < StepController
  def show
    @quiz = Quiz.new(current_user)
  end

  def update
    quiz = Quiz.new(current_user)
    if quiz.update_attributes(quiz_params)
      # not sure what we need here yet
      redirect_to root_path
    else
      raise 'whoops'
    end
  end

  private

  def quiz_params
    params[:quiz]
    # params.require(:quiz).permit(...)
  end
end

