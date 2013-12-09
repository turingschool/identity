module QuizProgression
  def quiz_generated?
    !quiz_questions.empty?
  end

  def quiz_complete?
    quiz_answers.size == quiz_questions.size
  end

  def quiz_result(slug, response)
    return unless current_quiz_question?(slug)
    quiz_answers[slug] = response
  end

  def current_quiz_question?(slug)
    next_quiz_question.slug == slug
  end

  def next_quiz_question
    remaining_questions.first
  end

  def remaining_questions
    quiz_questions.reject {|q| quiz_answers.keys.include?(q.slug)}
  end

  def quiz_score
    quiz_answers.select {|_, result| result}.size
  end

  def quiz_size
    quiz_questions.size
  end
end
