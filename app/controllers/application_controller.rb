class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def require_login
    if current_user.guest?
      redirect_to please_login_path, error: "Please log in"
    end
  end

  def login(user)
    @current_user = nil
    session[:user_id] = user.id
  end

  def logout
    @current_user = nil
    reset_session
  end

  def current_user
    return @current_user if @current_user

    if session[:user_id]
      @current_user = User.find_by_id(session[:user_id])
    elsif Rails.env.test?
      @current_user = $current_user
    end
    @current_user ||= Guest.new
    mark_user_active @current_user
    @current_user
  end

  private

  def mark_user_active(user)
    user.respond_to?(:application)     &&
      (application = user.application) &&
      application.hide_until_active    &&
      application.update_attribute(:hide_until_active, false)
  end
end
