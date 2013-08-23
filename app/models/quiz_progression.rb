module QuizProgression
  def quiz_generated?
    !quiz_questions.empty?
  end

  def quiz_result(slug, result)
    return unless slug == next_quiz_slug
    self.quiz_answers[slug] = result
  end

  def next_quiz_slug
    remaining_quiz_slugs.first
  end

  def remaining_quiz_slugs
    quiz_questions - quiz_answers.keys
  end

  # just for show
  def next_quiz_question_number
    i = quiz_questions.index(next_quiz_slug)
    i + 1 if i
  end

  def quiz_score
    quiz_answers.select {|_, result| result}.size
  end

  def quiz_size
    quiz_questions.size
  end
end
