class QuizController < ApplicationController
  before_filter :require_login, :apply

  def question
    @quiz = Quiz.new(current_user)

    if @quiz.complete?
      redirect_to quiz_complete_path and return
    end
  end

  def complete
    @application = current_user.application

    unless @application.quiz_complete?
      redirect_to quiz_question_path and return
    end

    @application.quiz_completed_at ||= Time.now
    @application.save
  end

  def update
    quiz = Quiz.new(current_user, params[:id].to_sym)
    if quiz.update_attributes(params[:quiz])
      redirect_to quiz_question_path
    else
      @quiz = quiz.question
      render :question
    end
  end

  private

  def apply
    current_user.apply!
  end
end
