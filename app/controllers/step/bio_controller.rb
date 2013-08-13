class Step::BioController < StepController
  def show
    @bio = Bio.new(current_user)
  end

  def update
    @bio = Bio.new(current_user)
    if @bio.update_attributes(bio_params)
      redirect_to step_edit_resume_path
    else
      render :show
    end
  end

  private

  def bio_params
    params.require(:bio).permit(:name, :email, :location)
  end

  def current_step
    :bio
  end
end
