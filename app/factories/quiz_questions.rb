class QuizQuestions
  def self.generate_for(application, started_at: nil)
    application.quiz_questions = Eloquiz.random_questions.each {|q|
      # trigger the options so they get saved
      # and the user gets a consistent set in the view
      q.options
    }
    application.quiz_started_at = started_at || Time.now
    application.save
  end
end
