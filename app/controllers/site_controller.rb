class SiteController < ApplicationController
  def index
    unless current_user.guest?
      current_user.apply
      @application = current_user.application
    end
  end
end