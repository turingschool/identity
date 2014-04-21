require './lib/github'

class SessionsController < ApplicationController

  def new
    session[:return_url] = params[:return_url] if params[:return_url]
    redirect_to Github.login_url
  end

  def show
  end

  def destroy
    logout
    flash[:notice] = "You have been logged out."
    redirect_to root_path
  end

  def callback
    unless params[:code]
      flash[:error] = "We didn't receive any authentication code from GitHub."
    end

    begin
      user = Authentication.perform(params[:code])
      login(user)
    rescue => e
      flash[:error] = "We're having trouble with logins right now. Please come back later."
    end

    if current_user.guest?
      flash[:error] = "We're having trouble with logins right now. Please come back later."
    end

    if session[:return_url]
      redirect_to session.delete(:return_url)
    elsif current_user.admin?
      redirect_to admin_path
    else
      redirect_to root_path
    end
  end
end
