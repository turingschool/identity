class AdminController < ApplicationController
  before_filter :require_login, :require_admin

  def require_admin
    unless current_user.admin?
      redirect_to root_path, error: 'That is a restricted section'
    end
  end
end

