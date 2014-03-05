module StepHelper
  def format_application_errors(application)
    errors = application.errors.full_messages
    errors.collect do |error|
      parts = error.split(" ")
      parts[1..-1].join(" ")
    end.join("<br/>")
  end

  def format_resume_errors(resume)
    resume.errors.full_messages.join("<br/>")
  end
end