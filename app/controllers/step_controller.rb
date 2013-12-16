class StepController < ApplicationController
  before_filter :require_login, :apply, :ensure_accessible_step

  def show
    step = current_user.application.next_step
    if step
      redirect_to send("step_edit_#{step}_path")
    else
      redirect_to step_edit_final_path
    end
  end

  private

  def ensure_accessible_step
    unless current_user.application.accessible?(current_step)
      redirect_to apply_path
    end
  end

  def apply
    current_user.apply!
  end

  def current_step
    :pre
  end
end
