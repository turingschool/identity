class QuizController < ApplicationController
  before_filter :require_login, :apply

  def question
    if current_user.application.quiz_complete?
      redirect quiz_complete_path and return
    end
    @question = QuizQuestion.new(current_user)
  end

  def complete
    @application = current_user.application
  end

  def update
    @question = QuizQuestion.new(current_user, params[:id])
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
