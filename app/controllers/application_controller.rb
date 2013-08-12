class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

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
    else
      @current_user = Guest.new
    end
  end
end
