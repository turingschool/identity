class Admin::DashboardController < AdminController
  def index
    @status_names = ApplicationStateMachine.valid_states
    @steps        = Application.steps
    @counts       = Application.breakdown
  end
end

