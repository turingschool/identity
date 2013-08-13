class StepController < ApplicationController
  before_filter :require_login

  def show
    current_user.apply!
    step = current_user.application.next_step
    redirect_to send("step_edit_#{step}_path")
  end
end
