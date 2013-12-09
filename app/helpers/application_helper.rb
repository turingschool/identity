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
end
