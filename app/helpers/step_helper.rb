module StepHelper
  def format_application_errors(application)
    errors = application.errors.full_messages
    errors.collect do |error|
      parts = error.split(" ")
      parts[1..-1].join(" ")
    end.join("<br/>")
  end

  def format_form_errors(object)
    object.errors.full_messages.join("<br/>").html_safe
  end
end