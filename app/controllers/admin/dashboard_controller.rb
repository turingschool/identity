class Admin::DashboardController < AdminController
  def index
    @status_names  = ApplicationStateMachine.valid_states
    @status_counts = Application.status_breakdown
    @steps         = Application.steps
    @step_counts   = Application.step_breakdown
  end
end
