class Admin::DashboardController < AdminController
  def index
    @steps = Application.steps
    @counts = Application.breakdown
  end
end

