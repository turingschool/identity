class Step::BioController < ApplicationController
  before_filter :require_login

  def show
    @bio = Bio.new(current_user)
  end

  def update
    bio = Bio.new(current_user)
    if bio.update_attributes(bio_params)
      redirect_to root_path
    else
      raise 'whoops'
    end
  end

  private

  def bio_params
    params.require(:bio).permit(:name, :email, :location)
  end

end
