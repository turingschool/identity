module AdminHelper
  def calculate_quiz_score(application)
    ((application.quiz_score / application.quiz_size.to_f) * 100).floor
  end
end