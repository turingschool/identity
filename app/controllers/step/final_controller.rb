class Step::FinalController < StepController
  def show
    @final = Final.new(current_user)
  end

  def update
    @final = Final.new(current_user)
    if @final.update_attributes
      redirect_to root_path
    else
      render :show
    end
  end

  private

  def final_params
    params.require(:final)
  end

  def current_step
    :final
  end
end