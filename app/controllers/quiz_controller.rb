class QuizController < ApplicationController
  before_filter :require_login, :apply

  def question
    i = current_user.application.next_quiz_question_number
    if i
      redirect_to quiz_path(i)
    else
      redirect_to quiz_complete_path
    end
  end

  def complete
    @application = current_user.application
  end

  def show
    @question = QuizQuestion.new(current_user)
  end

  def update
    @question = QuizQuestion.new(current_user, params[:id])
    if @question.update_attributes(params[:quiz])
      redirect_to quiz_index_path
    else
      render :show
    end
  end

  private

  def apply
    current_user.apply!
  end
end
