module Api
  class UsersController < ApiController
    def show
      render json: User.find(params[:id])
    end
  end
end
