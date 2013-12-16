class SiteController < ApplicationController
  def index
    unless current_user.guest?
      current_user.apply
    end
  end
end