module Steps
  def completed?(step)
    completed_steps.include?(step.to_s)
  end

  # Maybe use Set for :completed_steps
  def complete(step)
    completed_steps << step.to_s unless completed?(step)
  end

  def complete!(step)
    complete(step)
    save
  end

  # Not sure what we want to do after everything is completed
  def next_step
    progression.find do |step|
      !completed?(step)
    end
  end

  def progression
    [:bio, :resume, :essay, :video, :quiz]
  end

  def done?
    progression.all? {|step| completed?(step)}
  end

end
