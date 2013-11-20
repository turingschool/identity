module ApplicationHelper
  def total_applicants(counts)
    counts.each_value.collect.reduce(0, :+)
  end

  def applicants_per_step(counts, step)
    ((counts[step] / total_applicants(counts).to_f) * 100).round(2)
  end
end