module ApplicationHelper
  def total_applicants(counts)
    Application.count
  end

  def applicants_per_step(counts, step)
    ((counts[step] / total_applicants(counts).to_f) * 100).round(2)
  end

  def applicants_initials(applications)
    applications.collect{ |application| application.user.name[0] }.uniq
  end

  def format_response(response)
    if response
      "<p style='color:green'>Correct<p>".html_safe
    else
      "<p style='color:red'>Wrong<p>".html_safe
    end
  end

  def t(*args)
    super.html_safe
  end
end
