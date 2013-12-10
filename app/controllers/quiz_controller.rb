class QuizController < ApplicationController
  before_filter :require_login, :apply

  def question
    quiz = Quiz.new(current_user)

    if quiz.complete?
      redirect_to quiz_complete_path and return
    end

    @question = quiz.question
  end

  def complete
    @application = current_user.application
  end

  def update
    @question = Quiz.new(current_user, params[:id].to_sym)
    if @question.update_attributes(params[:quiz])
      redirect_to quiz_question_path
    else
      render :show
    end
  end

  private

  def apply
    current_user.apply!
  end
end
